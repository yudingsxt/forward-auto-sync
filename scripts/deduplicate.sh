#!/bin/bash

# Widget去重脚本
# 根据URL字段去除重复的widget条目

set -e

echo "开始去重Widget..."

# 项目根目录
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INPUT_FILE="$PROJECT_ROOT/widgets.fwd"
BACKUP_FILE="$PROJECT_ROOT/widgets.fwd.backup"
TEMP_FILE="$PROJECT_ROOT/widgets_dedup.tmp"

# 检查输入文件是否存在
if [ ! -f "$INPUT_FILE" ]; then
    echo "错误: 找不到 $INPUT_FILE"
    exit 1
fi

# 创建备份
cp "$INPUT_FILE" "$BACKUP_FILE"
echo "已创建备份: $BACKUP_FILE"

# 统计去重前的数量
original_count=$(jq '.widgets | length' "$INPUT_FILE")
echo "去重前widget数量: $original_count"

# 根据URL去重，保留第一个出现的widget
jq '.widgets |= (group_by(.url) | map(.[0])) | .widgets |= sort_by(.title)' "$INPUT_FILE" > "$TEMP_FILE"

# 统计去重后的数量
new_count=$(jq '.widgets | length' "$TEMP_FILE")
echo "去重后widget数量: $new_count"
echo "移除重复项: $((original_count - new_count)) 个"

# 替换原文件
mv "$TEMP_FILE" "$INPUT_FILE"

echo "去重完成！"
echo "原文件已更新: $INPUT_FILE"
echo "备份文件: $BACKUP_FILE"
