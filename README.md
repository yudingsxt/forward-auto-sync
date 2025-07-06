# Forward Auto Updater

🤖 自动化模块库更新项目

## 📋 项目简介

这是一个基于GitHub Actions的自动化模块库管理工具，可以定时或手动同步多个外部仓库的最新代码到当前项目中。

## ✨ 主要功能

- 🕐 **定时自动更新**：每天自动检查并同步配置的仓库
- 🎯 **手动精确控制**：支持指定仓库的手动更新
- 📦 **版本管理**：自动递增版本号并创建Git标签
- 📝 **更新日志**：自动生成详细的变更记录
- 🔄 **智能同步**：只在有实际更新时才提交更改

## 🚀 快速开始

### 1. 配置仓库列表

编辑 `config/repos.json` 文件，添加要同步的仓库：

```json
{
  "repositories": [
    {
      "name": "ForwardWidgets",
      "url": "https://github.com/huangxd-/ForwardWidgets",
      "branch": "main",
      "target_dir": "widgets/ForwardWidgets",
      "description": "示例模块库"
    }
  ],
  "settings": {
    "auto_commit": true,
    "update_frequency": "daily",
    "timezone": "Asia/Shanghai"
  }
}
```

### 2. 配置字段说明

| 字段 | 说明 | 示例 |
|------|------|------|
| `name` | 仓库名称（唯一标识） | `"ForwardWidgets"` |
| `url` | 仓库URL | `"https://github.com/user/repo"` |
| `branch` | 要同步的分支 | `"main"` 或 `"master"` |
| `target_dir` | 本地存储目录 | `"widgets/ForwardWidgets"` |
| `description` | 仓库描述 | `"示例模块库"` |

### 3. 自动化工作流

#### 定时更新
- **触发时间**：每天凌晨2点（UTC时间）
- **执行内容**：检查所有配置的仓库并同步更新
- **自动提交**：有更新时自动提交并创建版本标签

#### 手动更新
- **触发方式**：GitHub Actions页面手动执行
- **可选参数**：
  - `repository_name`：指定要更新的仓库名称
  - `force_update`：强制更新（即使没有变更）

## 📁 项目结构

```
forward/
├── .github/
│   └── workflows/
│       ├── sync-repos.yml        # 定时同步工作流
│       └── manual-update.yml     # 手动更新工作流
├── config/
│   └── repos.json               # 仓库配置文件
├── scripts/
│   └── update.sh                # 核心更新脚本
├── widgets/                     # 同步的模块库存储目录
├── issues/
│   └── 自动更新项目.md           # 项目计划文档
├── package.json                 # 版本管理
├── CHANGELOG.md                 # 更新日志
└── README.md                    # 项目说明
```

## 🔧 使用方法

### 添加新的模块库

1. 编辑 `config/repos.json`
2. 在 `repositories` 数组中添加新的仓库配置
3. 提交更改，等待下次自动更新或手动触发

### 手动触发更新

1. 进入GitHub仓库的Actions页面
2. 选择 "手动更新模块库" 工作流
3. 点击 "Run workflow"
4. 可选择指定仓库或强制更新

### 查看更新日志

查看 `CHANGELOG.md` 文件了解详细的更新记录。

## 📊 版本管理

- 使用语义化版本控制（Semantic Versioning）
- 每次更新自动递增补丁版本号
- 自动创建Git标签用于版本追踪

## 🛠️ 技术栈

- **GitHub Actions**：自动化工作流
- **Bash脚本**：核心更新逻辑
- **jq**：JSON数据处理
- **rsync**：文件同步
- **Git**：版本控制

## 📝 注意事项

1. 确保GitHub仓库有足够的权限进行提交和创建标签
2. 大型仓库同步可能需要较长时间
3. 建议定期检查同步日志确保正常运行
4. 可根据需要调整定时任务的执行频率

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个项目！

## 📄 许可证

MIT License