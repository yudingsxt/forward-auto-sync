#!/bin/bash

# 测试版本计算逻辑
# 模拟GitHub Actions中的版本计算过程

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "测试版本计算逻辑..."

# 模拟获取当前版本
CURRENT=$(jq -r '.version' "$PROJECT_ROOT/package.json")
echo "当前版本: $CURRENT"

# 获取最新的标签版本
LATEST_TAG=$(git tag -l | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -1)
if [ -n "$LATEST_TAG" ]; then
    LATEST_VERSION=${LATEST_TAG#v}
    echo "最新标签版本: $LATEST_VERSION"
    
    # 如果当前版本小于等于最新标签版本，则基于最新标签版本递增
    if [ "$(printf '%s\n' "$CURRENT" "$LATEST_VERSION" | sort -V | head -1)" = "$CURRENT" ] && [ "$CURRENT" != "$LATEST_VERSION" ]; then
        NEW=$(echo $LATEST_VERSION | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')
    else
        NEW=$(echo $CURRENT | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')
    fi
else
    NEW=$(echo $CURRENT | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')
fi

# 确保新版本标签不存在
while git rev-parse "v$NEW" >/dev/null 2>&1; do
    echo "标签 v$NEW 已存在，递增版本号..."
    NEW=$(echo $NEW | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')
done

echo "计算出的新版本: $NEW"
echo "新标签将是: v$NEW"

# 检查是否会有冲突
if git rev-parse "v$NEW" >/dev/null 2>&1; then
    echo "❌ 警告: 标签 v$NEW 已存在！"
else
    echo "✅ 标签 v$NEW 可以安全创建"
fi
