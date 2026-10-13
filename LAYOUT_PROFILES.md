# 多机型字体与坐标 Profile

更新日期：2026-08-12

## 架构

现代源码在 `CNWatchFaceView.mc` 中提供六个同名、带注解的 `loadLayoutProfile()`：

| 注解 | 主时间候选 | 侧栏 | 顶部天气 Y | 时间中心 Y | 日期中心 Y | 秒/AMPM 行距 | 中文日历最大字号 |
|---|---|---|---:|---:|---:|---:|---:|
| `Round240` | `HOT → MEDIUM → MILD` | `FONT_TINY` | `16%` | `34%` | `50%` | 1px | 22px |
| `Round260` | `HOT → MEDIUM → MILD` | `FONT_TINY` | `16%` | `34%` | `50%` | 1px | 24px |
| `Round280` | `HOT → MEDIUM → MILD` | `FONT_TINY` | `16%` | `34%` | `50%` | 1px | 26px |
| `Round390` | `HOT → MEDIUM → MILD` | `FONT_TINY` | `16%` | `34%` | `50%` | 4px | 34px |
| `Round416` | `HOT → MEDIUM → MILD` | `FONT_TINY` | `16%` | `34%` | `50%` | 4px | 36px |
| `Round454` | `HOT → MEDIUM → MILD` | `FONT_TINY` | `16%` | `34%` | `50%` | 4px | 39px |

`monkey.jungle` 根据 SDK 9.2 `compiler.json.deviceFamily` 为每个现代产品排除其他四个实现。每个 PRG 只保留自己的 profile；新增产品时必须先确认官方 device family，再补 Jungle 映射。

本副本只保留现代布局路径：现代 `Round240`、`Round260`、`Round280`、`Round390`、`Round416` 和 `Round454`。旧布局源码与旧资源不属于本项目。

## 时间与下部区域依赖

```text
最坏时间字符串宽度 + 侧栏最坏宽度
                ↓
       居中的完整时间组件
        profile 日期中心槽（50%）
                 ↓ 横向弦宽 + 字段行上界双约束
             三个自定义字段（61%）
                 ↓
       左右目标弧与底部电量区
```

- 主时间使用固定的最坏字符串槽位，当前时间变化不会导致 X 抖动。
- 秒和 AM/PM 是同一个侧栏块；两行高度为 `2 × fontHeight + lineGap`。
- 日期不直接累加系统数字字体的 line box；该 line box 在部分设备含较大的不可见 leading。日期使用 profile 的 50% 视觉中心槽。
- 日期字体从 profile 上限逐级缩小，必须同时满足圆屏弦宽和不进入 61% 状态行；只把字段间距压到零不算成功。
- 字段行至少位于日期底边加一个小字体半高之后。
- 左右目标弧固定在下半表盘两侧，不进入日期行。
- 底部电量区在字段行和目标弧之后统一计算，避免与字段重叠。

## 调整规则

1. 字体档位、时间中心和间距只在对应 `loadLayoutProfile()` 中修改。
2. 不得在共享绘制流程添加 `if (device)` 或独立 `+/-px` 修补。
3. 改字体后必须重新检查该分辨率内至少两个不同字体签名。
4. 修改 profile 后至少复测 12/24 小时、秒开关、AM/PM、最长中文日历和睡眠/AOD。
5. 新分辨率先新增注解 profile 和 Jungle 排除，再加入 Manifest。

## 验收要求

- 每个 profile 至少编译一个对应屏幕族代表设备。
- 需要检查 12/24 小时、秒开关、AM/PM、最长中文日期和睡眠/AOD。
- 需要确认天气行、日期行、三个字段、左右目标弧和电量区没有越界或重叠。
