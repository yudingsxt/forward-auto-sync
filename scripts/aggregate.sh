#!/bin/bash

# 极简Widget汇聚脚本
# 直接合并所有.fwd文件中的widgets，不进行校验和去重

set -e

# 清理函数
cleanup() {
    rm -f "$TEMP_WIDGETS" 2>/dev/null || true
}
trap cleanup EXIT

echo "开始汇聚Widget模块..."

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WIDGETS_DIR="$PROJECT_ROOT/widgets"
OUTPUT_FILE="$PROJECT_ROOT/widgets.fwd"
TEMP_WIDGETS="$PROJECT_ROOT/temp_widgets.json"

# 确保widgets目录存在
mkdir -p "$WIDGETS_DIR"

# 初始化空的widgets数组
echo '[]' > "$TEMP_WIDGETS"

# 遍历所有.fwd文件并直接合并
for fwd_file in "$WIDGETS_DIR"/*/*.fwd; do
    [ -f "$fwd_file" ] || continue
    
    echo "处理: $fwd_file"
    
    # 直接提取widgets数组，忽略格式错误
    widgets_array=$(jq '.widgets // []' "$fwd_file" 2>/dev/null || echo '[]')
    
    # 合并到临时文件
    jq --argjson new_widgets "$widgets_array" '. + $new_widgets' "$TEMP_WIDGETS" > "${TEMP_WIDGETS}.tmp" && mv "${TEMP_WIDGETS}.tmp" "$TEMP_WIDGETS"
done

# 生成最终文件
total_widgets=$(jq 'length' "$TEMP_WIDGETS")
echo "汇聚完成！共 $total_widgets 个widgets"

# 生成.fwd格式文件
jq -n --argjson widgets "$(cat "$TEMP_WIDGETS")" '{
  "title": "Forward Widgets Collection",
  "description": "汇聚的Forward Widgets模块集合",
  "icon": "https://assets.vvebo.vip/scripts/icon.png",
  "widgets": $widgets
}' > "$OUTPUT_FILE"

echo "输出文件: $OUTPUT_FILE"