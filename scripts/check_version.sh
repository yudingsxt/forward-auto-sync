#!/bin/bash

# 版本同步检查脚本
# 检查package.json版本与Git标签的同步状态

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "检查版本同步状态..."

# 获取当前package.json版本
CURRENT=$(jq -r '.version' "$PROJECT_ROOT/package.json")
echo "package.json版本: $CURRENT"

# 获取最新Git标签
LATEST_TAG=$(git tag -l | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -1)
if [ -n "$LATEST_TAG" ]; then
    LATEST_VERSION=${LATEST_TAG#v}
    echo "最新Git标签: $LATEST_TAG ($LATEST_VERSION)"
    
    if [ "$CURRENT" = "$LATEST_VERSION" ]; then
        echo "✅ 版本同步正常"
    else
        echo "❌ 版本不同步"
        echo "建议操作:"
        
        # 比较版本
        if [ "$(printf '%s\n' "$CURRENT" "$LATEST_VERSION" | sort -V | head -1)" = "$CURRENT" ]; then
            if [ "$CURRENT" != "$LATEST_VERSION" ]; then
                echo "  package.json版本较旧，应更新为: $LATEST_VERSION"
                read -p "是否自动更新package.json版本? (y/N): " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    jq --arg version "$LATEST_VERSION" '.version = $version' "$PROJECT_ROOT/package.json" > "$PROJECT_ROOT/package.json.tmp"
                    mv "$PROJECT_ROOT/package.json.tmp" "$PROJECT_ROOT/package.json"
                    echo "✅ 已更新package.json版本为: $LATEST_VERSION"
                fi
            fi
        else
            echo "  package.json版本较新，下次更新时会创建新标签"
        fi
    fi
else
    echo "⚠️  没有找到Git标签"
fi

echo ""
echo "所有Git标签:"
git tag -l | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -V
