#!/bin/bash

# Widget重复检查脚本
# 检查widgets.fwd文件中是否存在重复的URL

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INPUT_FILE="$PROJECT_ROOT/widgets.fwd"

if [ ! -f "$INPUT_FILE" ]; then
    echo "错误: 找不到 $INPUT_FILE"
    exit 1
fi

echo "检查Widget重复项..."

total_count=$(jq '.widgets | length' "$INPUT_FILE")
unique_count=$(jq -r '.widgets[].url' "$INPUT_FILE" | sort | uniq | wc -l)

echo "总widget数量: $total_count"
echo "唯一URL数量: $unique_count"

if [ "$total_count" -eq "$unique_count" ]; then
    echo "✅ 没有发现重复的URL"
else
    echo "❌ 发现 $((total_count - unique_count)) 个重复URL:"
    jq -r '.widgets[].url' "$INPUT_FILE" | sort | uniq -d
fi

echo ""
echo "widget列表 (按标题排序):"
jq -r '.widgets[] | "- \(.title) (\(.author)): \(.url)"' "$INPUT_FILE" | sort
