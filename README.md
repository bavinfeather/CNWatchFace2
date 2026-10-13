# 几何山景MAX2

几何山景MAX2的全新现代设备表盘项目，基于 Garmin Connect IQ 中文数据表盘实现。

表盘以实时绘图方式重建天空、山峰、天气、时间、日期、字段和目标进度。

当前副本只使用现代 `source` 和现代布局 profile，不包含 `source-legacy` 或 `resources-legacy`。支持设备清单见 [SUPPORTED_DEVICES.md](SUPPORTED_DEVICES.md)。

跨机型字体和坐标由编译期 profile 管理，结构与调整门禁见 [LAYOUT_PROFILES.md](LAYOUT_PROFILES.md)。

主要功能：

- 放大的系统时间
- 顶部天气使用两个天气数据组合，以逗号分隔
- 中部保留系统时间和日期；时间使用暖白色作为最高亮度元素
- 下部三个自定义字段显示数值和英文缩写，支持多种活动与身体数据
- 左右两个贴边弧形目标只显示图标和完成进度，目标值由用户以 km 填写
- 最下方显示电池图标和电量百分比，低于 20% 时使用警示色
- AMOLED 常亮模式使用黑底精简画面，并按分钟轻微移动以降低烧屏风险
- 天空与远/中/近三层山峰颜色可独立配置（多套配色）
- 手机与手表端设置均已简体中文 / 英文本地化

所有支持的圆形现代设备按 `Round240`、`Round260`、`Round280`、`Round390`、`Round416`、`Round454` profile 编译，保持同一套表盘结构并按尺寸适配。

## 构建

1. 在 VS Code 中打开本目录。
2. 运行 `Monkey C: Run Without Debugging`。
3. MIP 可选择 `fenix7pro_sim`；AMOLED 建议分别选择 `epix2pro42mm_sim`、`fenix843mm_sim` 和 `fenix847mm_sim`。

发布到 Connect IQ Store 前，使用 `Monkey C: Export Project` 生成 `.iq` 文件。

## 洁净实现原则

- 不复制无明确许可证项目的源码、字体、图标、图片或设置文件。
- 功能需求可以参考用户体验，但代码和视觉资产必须独立设计与实现。
- 引入任何第三方内容前必须先确认许可证，并保存版权声明和来源。
- 免费发布不等于开源；当前项目采用保留所有权利的许可证。
