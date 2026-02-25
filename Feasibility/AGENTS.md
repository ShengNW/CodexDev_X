# AGENTS.md

本目录的主上下文入口是：

- `/root/autodl-tmp/X/CodexDev/Feasibility/Phase1.md`

新开 Codex 必须先阅读 `Phase1.md`，再执行任何分析、训练、评估、打包任务。

## 快速说明

- `Phase1.md` 已沉淀完整基线：
  - 全链路背景与阶段结论（P1/P2/P2.5/P2.6）
  - 关键绝对路径
  - 编码与配对规则（含 `gb18030`）
  - 评估协议 V2 与常见坑
  - 对外报告与试标包位置

## 执行原则

1. 所有路径使用绝对路径。
2. 优先复用既有脚本与配置，不重复造轮子。
3. 不改原始数据目录（只读）。
4. 解释器固定：`/root/miniconda3/bin/python`。

