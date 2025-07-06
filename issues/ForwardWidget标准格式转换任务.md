# ForwardWidget标准格式转换任务

## 任务背景
用户反馈导入软件时显示校验信息失败，经分析发现当前widgets.fwd文件使用简化格式，缺少标准WidgetMetadata格式的必要字段。

## 选定方案
方案2：转换为标准格式
- 将widgets.fwd转换为完整的WidgetMetadata格式
- 为每个widget添加site和modules字段
- 更新版本号并提交代码

## 执行计划

### 步骤1：备份当前文件
- 备份现有widgets.fwd文件

### 步骤2：转换widgets.fwd格式
- 为每个widget添加site字段（根据author映射到对应仓库）
- 为每个widget添加modules字段（包含title、description、requiresWebView、functionName、sectionMode、params）
- 保持现有的id、title、description、requiredVersion、version、author、url字段

### 步骤3：更新版本号
- 更新package.json中的版本号（从1.0.20到1.0.21）

### 步骤4：验证格式
- 运行聚合脚本验证新格式是否通过校验

### 步骤5：提交代码
- 提交修改到git仓库

## 预期结果
- widgets.fwd文件符合标准WidgetMetadata格式
- 导入软件校验通过
- 版本号正确更新
- 代码成功提交