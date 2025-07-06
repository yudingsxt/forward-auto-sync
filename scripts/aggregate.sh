#!/bin/bash

# 汇聚Widget模块脚本
# 用于合并所有ForwardWidgets仓库的模块到一个文件中

# 错误处理配置
set -euo pipefail

# 全局错误计数器
ERROR_COUNT=0
WARNING_COUNT=0

# 陷阱函数：确保资源清理
cleanup() {
    local exit_code=$?
    echo "清理临时文件..."
    rm -f "$TEMP_WIDGETS" "${TEMP_WIDGETS}.tmp" 2>/dev/null || true
    if [ $exit_code -ne 0 ]; then
        echo "脚本异常退出，错误码: $exit_code"
    fi
    exit $exit_code
}
trap cleanup EXIT INT TERM

# 错误记录函数
log_error() {
    echo "❌ 错误: $1" >&2
    ((ERROR_COUNT++))
}

log_warning() {
    echo "⚠️ 警告: $1" >&2
    ((WARNING_COUNT++))
}

log_info() {
    echo "ℹ️ $1"
}

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
    
    echo "处理完成，共 $original_count 个模块"
}

# 模块校验函数（原始格式）
validate_widget() {
    local widget="$1"
    local required_fields=("id" "title" "description" "author" "version" "requiredVersion" "url")
    
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
    log_error "widgets目录不存在: $WIDGETS_DIR"
    log_info "尝试创建widgets目录..."
    mkdir -p "$WIDGETS_DIR" || {
        log_error "无法创建widgets目录，脚本终止"
        exit 1
    }
    log_info "widgets目录已创建"
fi

# 创建临时文件存储合并的widgets
TEMP_WIDGETS="$(mktemp)"
echo "[]" > "$TEMP_WIDGETS"

# 遍历所有.fwd文件
while IFS= read -r -d '' fwd_file; do
    log_info "处理文件: $fwd_file"
    
    # 检查文件是否为有效JSON
    if ! jq empty "$fwd_file" 2>/dev/null; then
        log_warning "$fwd_file JSON格式有误，跳过此文件"
        log_info "提示: 请检查文件中是否有多余的逗号或其他JSON语法错误"
        # 尝试提供更详细的错误信息
        jq_error=$(jq empty "$fwd_file" 2>&1 || true)
        log_info "JSON错误详情: $jq_error"
        continue
    fi
    
    # 提取widgets数组，保持原始格式不变
    if jq -e '.widgets' "$fwd_file" >/dev/null 2>&1; then
        # 直接提取widgets数组，不做任何格式转换
        temp_processed="$(mktemp)"
        
        # 根据文件路径过滤widgets，避免重复
        if [[ "$fwd_file" == *"pack1r"* ]]; then
            # pack1r文件只保留pack1r作者的widgets
            jq '.widgets | map(select(.author == "pack1r"))' "$fwd_file" > "$temp_processed"
        else
            # 其他文件保留所有widgets，完全不修改原始格式
            jq '.widgets' "$fwd_file" > "$temp_processed"
        fi
        
        # 统计合并数量
        widget_count=$(jq 'length' "$temp_processed")
        
        # 合并到主文件
        jq -s '.[0] + .[1]' "$TEMP_WIDGETS" "$temp_processed" > "${TEMP_WIDGETS}.tmp"
        mv "${TEMP_WIDGETS}.tmp" "$TEMP_WIDGETS"
        rm -f "$temp_processed"
        log_info "已合并 $widget_count 个widgets (保持原始格式)"
    else
        log_warning "$fwd_file 中没有找到widgets数组"
    fi
done < <(find "$WIDGETS_DIR" -name "*.fwd" -type f -print0)

# 跳过去重处理，保持所有模块
echo "跳过去重处理，保持所有模块..."
TEMP_DEDUPLICATED="$TEMP_WIDGETS"

# 校验模块
log_info "开始校验模块..."
VALID_COUNT=0
INVALID_COUNT=0

while IFS= read -r widget; do
    # 临时禁用set -e以避免校验失败时退出
    set +e
    validate_widget "$widget"
    validation_result=$?
    set -e
    
    if [ $validation_result -eq 0 ]; then
        ((VALID_COUNT++))
    else
        ((INVALID_COUNT++))
        widget_id=$(echo "$widget" | jq -r '.id // "unknown"')
        log_warning "模块校验失败: $widget_id"
    fi
done < <(jq -c '.[]' "$TEMP_DEDUPLICATED")

log_info "校验完成: 有效模块 $VALID_COUNT 个，无效模块 $INVALID_COUNT 个"

# 如果有无效模块，记录警告但继续处理
if [ $INVALID_COUNT -gt 0 ]; then
    log_warning "发现 $INVALID_COUNT 个无效模块，但继续处理（容错模式）"
fi

# 生成最终的汇聚文件（保持原始格式）
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

# 生成widgets.fwd文件（保持原始格式）
echo "正在生成widgets.fwd文件..."
SIMPLE_OUTPUT="$PROJECT_ROOT/widgets.fwd"

# 直接复制，保持原始格式不变
cp "$OUTPUT_FILE" "$SIMPLE_OUTPUT"

# 清理临时文件
rm -f "$TEMP_WIDGETS"

# 统计结果
WIDGET_COUNT=$(jq '.widgets | length' "$OUTPUT_FILE")
log_info "汇聚完成! 共合并 $WIDGET_COUNT 个widgets"
log_info "输出文件: $OUTPUT_FILE"
log_info "原始格式文件: $SIMPLE_OUTPUT"

# 显示汇聚文件的基本信息
echo "\n=== 汇聚文件信息 ==="
echo "标题: $(jq -r '.title' "$OUTPUT_FILE")"
echo "描述: $(jq -r '.description' "$OUTPUT_FILE")"
echo "Widget数量: $WIDGET_COUNT"
echo "有效模块: $VALID_COUNT 个"
echo "无效模块: $INVALID_COUNT 个"

# 显示重复ID统计（仅供参考）
DUPLICATE_IDS=$(jq -r '.widgets | group_by(.id) | map(select(length > 1)) | map(.[0].id) | .[]' "$OUTPUT_FILE" 2>/dev/null || echo "")
if [ -n "$DUPLICATE_IDS" ]; then
    echo "\n📊 重复ID统计:"
    echo "$DUPLICATE_IDS"
else
    echo "\n✅ 无重复ID"
fi

echo "\n=== Widget列表 ==="
jq -r '.widgets[] | "- \(.id): \(.title) (v\(.version)) - \(.author)"' "$OUTPUT_FILE"

echo "\nWidget汇聚完成!"

# 错误统计汇总
echo "\n=== 执行统计 ==="
log_info "错误数量: $ERROR_COUNT"
log_info "警告数量: $WARNING_COUNT"

# 根据错误情况决定退出状态
if [ $ERROR_COUNT -gt 0 ]; then
    log_error "脚本执行过程中发现 $ERROR_COUNT 个错误"
    exit 1
elif [ $WARNING_COUNT -gt 0 ]; then
    log_warning "脚本执行过程中发现 $WARNING_COUNT 个警告，但已成功完成"
    exit 0
else
    log_info "脚本执行完成，无错误或警告"
    exit 0
fi