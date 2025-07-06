#!/bin/bash

# 汇聚所有ForwardWidgets仓库的.fwd文件
# 生成统一的forward-widgets.fwd文件
# 支持去重和版本管理

set -e

echo "开始汇聚Widget模块..."

# 版本比较函数
compare_versions() {
    local version1="$1"
    local version2="$2"
    
    # 移除版本号中的非数字字符，保留点号
    version1=$(echo "$version1" | sed 's/[^0-9.]//g')
    version2=$(echo "$version2" | sed 's/[^0-9.]//g')
    
    # 使用sort -V进行版本比较
    if printf '%s\n%s\n' "$version1" "$version2" | sort -V -C; then
        echo "0"  # version1 <= version2
    else
        echo "1"  # version1 > version2
    fi
}

# 去重函数
deduplicate_widgets() {
    local input_file="$1"
    local output_file="$2"
    
    # 使用jq进行去重，保留最新版本
    jq '
        # 按ID分组
        group_by(.id) | 
        map(
            if length > 1 then
                # 如果有重复，按版本排序并取最新版本
                (sort_by(.version | split(".") | map(tonumber)) | reverse | .[0])
            else
                .[0]
            end
        ) |
        # 确保结果是唯一的
        unique_by(.id)
    ' "$input_file" > "$output_file"
    
    local original_count=$(jq 'length' "$input_file")
    local deduplicated_count=$(jq 'length' "$output_file")
    local removed_count=$((original_count - deduplicated_count))
    
    echo "去重完成，处理了 $original_count 个模块，去重后剩余 $deduplicated_count 个模块，移除了 $removed_count 个重复模块"
}

# 模块校验函数
validate_widget() {
    local widget="$1"
    local required_fields=("id" "title" "description" "author" "site" "version" "requiredVersion" "modules" "url")
    
    for field in "${required_fields[@]}"; do
        if ! echo "$widget" | jq -e ".$field" >/dev/null 2>&1; then
            echo "警告: 模块缺少必要字段: $field"
            return 1
        fi
    done
    return 0
}

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WIDGETS_DIR="$PROJECT_ROOT/widgets"
OUTPUT_FILE="$PROJECT_ROOT/forward-widgets.fwd"

# 检查widgets目录是否存在
if [ ! -d "$WIDGETS_DIR" ]; then
    echo "错误: widgets目录不存在"
    exit 1
fi

# 创建临时文件存储合并的widgets
TEMP_WIDGETS="$(mktemp)"
echo "[]" > "$TEMP_WIDGETS"

# 遍历所有.fwd文件
while IFS= read -r -d '' fwd_file; do
    echo "处理文件: $fwd_file"
    
    # 检查文件是否为有效JSON，如果不是则跳过（只读模式，不修复）
    if ! jq empty "$fwd_file" 2>/dev/null; then
        echo "警告: $fwd_file JSON格式有误，跳过此文件（只读模式）"
        continue
    fi
    
    # 提取widgets数组并转换为标准WidgetMetadata格式
    if jq -e '.widgets' "$fwd_file" >/dev/null 2>&1; then
        # 转换每个widget为标准WidgetMetadata格式
        temp_processed="$(mktemp)"
        
        # 根据文件路径过滤widgets，避免重复
        if [[ "$fwd_file" == *"pack1r"* ]]; then
            # pack1r文件只保留pack1r作者的widgets
            jq '.widgets | map(select(.author == "pack1r")) | map(
                # 添加site字段
                (if .author == "huangxd" then
                    . + {"site": "https://github.com/huangxd-/ForwardWidgets"}
                elif .author == "两块" then
                    . + {"site": "https://github.com/2kuai/ForwardWidgets"}
                elif .author == "pack1r" then
                    . + {"site": "https://github.com/pack1r/ForwardWidgets"}
                else
                    . + {"site": "https://github.com/unknown/ForwardWidgets"}
                end) |
                # 转换为WidgetMetadata格式
                {
                    "id": .id,
                    "title": .title,
                    "description": .description,
                    "author": .author,
                    "site": .site,
                    "version": .version,
                    "requiredVersion": .requiredVersion,
                    "modules": [
                        {
                            "title": .title,
                            "description": .description,
                            "requiresWebView": false,
                            "functionName": (.id | gsub("[^a-zA-Z0-9]"; "_")),
                            "sectionMode": false,
                            "params": []
                        }
                    ],
                    "url": .url
                }
            )' "$fwd_file" > "$temp_processed"
        else
            # 其他文件保留所有widgets
            jq '.widgets | map(
                # 添加site字段
                (if .author == "huangxd" then
                    . + {"site": "https://github.com/huangxd-/ForwardWidgets"}
                elif .author == "两块" then
                    . + {"site": "https://github.com/2kuai/ForwardWidgets"}
                elif .author == "pack1r" then
                    . + {"site": "https://github.com/pack1r/ForwardWidgets"}
                else
                    . + {"site": "https://github.com/unknown/ForwardWidgets"}
                end) |
                # 转换为WidgetMetadata格式
                {
                    "id": .id,
                    "title": .title,
                    "description": .description,
                    "author": .author,
                    "site": .site,
                    "version": .version,
                    "requiredVersion": .requiredVersion,
                    "modules": [
                        {
                            "title": .title,
                            "description": .description,
                            "requiresWebView": false,
                            "functionName": (.id | gsub("[^a-zA-Z0-9]"; "_")),
                            "sectionMode": false,
                            "params": []
                        }
                    ],
                    "url": .url
                }
            )' "$fwd_file" > "$temp_processed"
        fi
        
        # 合并到主文件
        jq -s '.[0] + .[1]' "$TEMP_WIDGETS" "$temp_processed" > "${TEMP_WIDGETS}.tmp"
        mv "${TEMP_WIDGETS}.tmp" "$TEMP_WIDGETS"
        rm -f "$temp_processed"
        echo "已合并 $(jq '.widgets | length' "$fwd_file") 个widgets (已转换为WidgetMetadata格式)"
    else
        echo "警告: $fwd_file 中没有找到widgets数组"
    fi
done < <(find "$WIDGETS_DIR" -name "*.fwd" -type f -print0)

# 去重处理
echo "开始去重处理..."
TEMP_DEDUPLICATED="$(mktemp)"
deduplicate_widgets "$TEMP_WIDGETS" "$TEMP_DEDUPLICATED"

# 校验模块
echo "开始校验模块..."
VALID_COUNT=0
INVALID_COUNT=0

while IFS= read -r widget; do
    if validate_widget "$widget"; then
        ((VALID_COUNT++))
    else
        ((INVALID_COUNT++))
        echo "模块校验失败: $(echo "$widget" | jq -r '.id // "unknown"')"
    fi
done < <(jq -c '.[]' "$TEMP_DEDUPLICATED")

echo "校验完成: 有效模块 $VALID_COUNT 个，无效模块 $INVALID_COUNT 个"

# 如果有无效模块，只记录警告但继续处理（只读模式）
if [ $INVALID_COUNT -gt 0 ]; then
    echo "⚠️ 发现 $INVALID_COUNT 个无效模块，但继续处理（只读模式）"
fi

# 生成最终的汇聚文件
cat > "$OUTPUT_FILE" << EOF
{
  "title": "Forward Widgets Collection",
  "description": "汇聚所有ForwardWidgets仓库的模块集合",
  "icon": "https://assets.vvebo.vip/scripts/icon.png",
  "widgets": $(cat "$TEMP_DEDUPLICATED")
}
EOF

# 格式化JSON文件
if command -v jq >/dev/null 2>&1; then
    jq '.' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp"
    mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"
fi

# 生成简化格式的widgets.fwd文件（供软件识别）
echo "正在生成简化格式的widgets.fwd文件..."
SIMPLE_OUTPUT="$PROJECT_ROOT/widgets.fwd"

# 转换为简化格式
jq '{
  title: .title,
  description: .description,
  icon: .icon,
  widgets: [.widgets[] | {
    id: .id,
    title: .title,
    description: .description,
    requiredVersion: .requiredVersion,
    version: .version,
    author: .author,
    url: .url
  }]
}' "$OUTPUT_FILE" > "$SIMPLE_OUTPUT"

# 清理临时文件
rm -f "$TEMP_WIDGETS" "$TEMP_DEDUPLICATED"

# 统计结果
WIDGET_COUNT=$(jq '.widgets | length' "$OUTPUT_FILE")
echo "汇聚完成! 共合并 $WIDGET_COUNT 个widgets"
echo "输出文件: $OUTPUT_FILE"
echo "简化格式文件: $SIMPLE_OUTPUT"

# 显示汇聚文件的基本信息
echo "\n=== 汇聚文件信息 ==="
echo "标题: $(jq -r '.title' "$OUTPUT_FILE")"
echo "描述: $(jq -r '.description' "$OUTPUT_FILE")"
echo "Widget数量: $WIDGET_COUNT"
echo "有效模块: $VALID_COUNT 个"
echo "无效模块: $INVALID_COUNT 个"

# 检查重复ID
DUPLICATE_IDS=$(jq -r '.widgets | group_by(.id) | map(select(length > 1)) | map(.[0].id) | .[]' "$OUTPUT_FILE" 2>/dev/null || echo "")
if [ -n "$DUPLICATE_IDS" ]; then
    echo "\n⚠️  警告: 发现重复ID:"
    echo "$DUPLICATE_IDS"
else
    echo "\n✅ 无重复ID，去重成功"
fi

echo "\n=== Widget列表 ==="
jq -r '.widgets[] | "- \(.id): \(.title) (v\(.version)) - \(.author)"' "$OUTPUT_FILE"

echo "\nWidget汇聚完成!"