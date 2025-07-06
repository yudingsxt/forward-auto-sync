# ForwardWidget标准格式转换任务

## 任务背景
用户反馈软件内显示"缺少校验信息无法添加模块链接"，经分析发现当前汇聚文件格式不符合ForwardWidget标准规范。

## 问题分析
- 当前forward-widgets.fwd为简单widgets数组格式
- 缺少标准WidgetMetadata对象结构
- 缺少modules字段和functionName配置
- 缺少完整的元数据信息

## 选定方案
**方案1：转换为标准WidgetMetadata格式**
- 将每个widget重构为完整的WidgetMetadata对象
- 添加modules数组，包含title、description、functionName等
- 保持向后兼容，自动推断functionName

## 详细执行计划

### 步骤1：分析源文件结构
- 检查widgets/目录下各仓库的.fwd文件格式
- 分析现有widget的id、title、url等字段
- 确定functionName推断规则

### 步骤2：设计标准格式转换逻辑
- 为每个widget生成完整的WidgetMetadata结构
- 添加modules数组，包含：
  - title: 使用widget.title
  - description: 使用widget.description
  - functionName: 从widget.id推断或使用默认值
  - requiresWebView: 默认false
  - sectionMode: 默认false
  - params: 空数组

### 步骤3：修改aggregate.sh脚本
- 更新JSON生成逻辑
- 实现widget到WidgetMetadata的转换
- 保持site字段映射功能
- 添加modules数组生成

### 步骤4：测试和验证
- 运行修改后的汇聚脚本
- 验证生成的forward-widgets.fwd格式
- 确保符合ForwardWidget标准规范

### 步骤5：版本更新和提交
- 更新package.json版本号
- 提交代码修改
- 创建版本标签

## 预期结果
- 生成符合ForwardWidget标准的汇聚文件
- 解决"缺少校验信息"的问题
- 保持所有现有widget功能正常

## 技术要点
- 使用jq进行复杂JSON转换
- 实现functionName自动推断
- 保持向后兼容性