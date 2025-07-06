# ForwardWidget格式修复任务

## 背景
用户反馈汇聚的模块无法使用，经分析发现当前汇聚文件格式不符合ForwardWidget标准规范。

## 问题分析
- 缺少`site`字段：每个widget必须包含网站地址
- 格式不完整：缺少ForwardWidget规范要求的关键字段
- 汇聚脚本未按标准格式生成文件

## 选定方案
**方案一：保持简化格式，补充必要字段**
- 为每个widget添加`site`字段
- 保持当前的widgets数组结构
- 最小化改动，确保兼容性

## 执行计划

### 步骤1：分析源文件格式
- 检查`widgets/ForwardWidgets-huangxd/widgets.fwd`
- 检查`widgets/ForwardWidgets-2kuai/forward-widgets.fwd`
- 确定author与site的映射关系

### 步骤2：修改汇聚脚本
- 修改`scripts/aggregate.sh`
- 添加site字段映射逻辑
- 根据author信息推断网站地址
- 确保生成符合ForwardWidget规范的JSON

### 步骤3：测试和验证
- 运行修改后的汇聚脚本
- 验证生成的`forward-widgets.fwd`格式
- 确保所有widget包含必要字段

### 步骤4：版本更新和提交
- 更新版本号到v1.0.12
- 提交修复代码
- 推送到远程仓库

## 预期结果
生成符合ForwardWidget标准的汇聚文件，解决模块无法使用的问题。