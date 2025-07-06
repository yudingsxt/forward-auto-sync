#!/bin/bash

# 汇聚所有ForwardWidgets仓库的.fwd文件
# 生成统一的forward-widgets.fwd文件

set -e

echo "开始汇聚Widget模块..."

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
find "$WIDGETS_DIR" -name "*.fwd" -type f | while read -r fwd_file; do
    echo "处理文件: $fwd_file"
    
    # 检查文件是否为有效JSON，如果不是则尝试修复常见问题
    if ! jq empty "$fwd_file" 2>/dev/null; then
        echo "警告: $fwd_file JSON格式有误，尝试自动修复..."
        
        # 创建临时文件进行修复
        temp_file="${fwd_file}.tmp"
        cp "$fwd_file" "$temp_file"
        
        # 修复多种常见的JSON格式问题
        # 检测操作系统并使用相应的sed语法
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' 's/},\s*]/}]/g' "$temp_file"
            sed -i '' 's/},\s*}/}}/g' "$temp_file"
        else
            # Linux
            sed -i 's/},\s*]/}]/g' "$temp_file"
            sed -i 's/},\s*}/}}/g' "$temp_file"
        fi
        
        # 再次检查是否修复成功
        if jq empty "$temp_file" 2>/dev/null; then
            mv "$temp_file" "$fwd_file"
            echo "✅ $fwd_file JSON格式修复成功"
        else
            rm -f "$temp_file"
            echo "错误: $fwd_file 修复失败，跳过此文件"
            continue
        fi
    fi
    
    # 提取widgets数组并合并
    if jq -e '.widgets' "$fwd_file" >/dev/null 2>&1; then
        jq -s '.[0] + .[1].widgets' "$TEMP_WIDGETS" "$fwd_file" > "${TEMP_WIDGETS}.tmp"
        mv "${TEMP_WIDGETS}.tmp" "$TEMP_WIDGETS"
        echo "已合并 $(jq '.widgets | length' "$fwd_file") 个widgets"
    else
        echo "警告: $fwd_file 中没有找到widgets数组"
    fi
done

# 生成最终的汇聚文件
cat > "$OUTPUT_FILE" << EOF
{
  "title": "Forward Widgets Collection",
  "description": "汇聚所有ForwardWidgets仓库的模块集合",
  "icon": "https://assets.vvebo.vip/scripts/icon.png",
  "widgets": $(cat "$TEMP_WIDGETS")
}
EOF

# 格式化JSON文件
if command -v jq >/dev/null 2>&1; then
    jq '.' "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp"
    mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"
fi

# 清理临时文件
rm -f "$TEMP_WIDGETS"

# 统计结果
WIDGET_COUNT=$(jq '.widgets | length' "$OUTPUT_FILE")
echo "汇聚完成! 共合并 $WIDGET_COUNT 个widgets"
echo "输出文件: $OUTPUT_FILE"

# 显示汇聚文件的基本信息
echo "\n=== 汇聚文件信息 ==="
echo "标题: $(jq -r '.title' "$OUTPUT_FILE")"
echo "描述: $(jq -r '.description' "$OUTPUT_FILE")"
echo "Widget数量: $WIDGET_COUNT"

echo "\n=== Widget列表 ==="
jq -r '.widgets[] | "- \(.id): \(.title) (v\(.version))"' "$OUTPUT_FILE"

echo "\nWidget汇聚完成!"