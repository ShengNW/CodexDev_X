# Baidu 网盘目录下载报告

- 执行时间: 2026-02-19
- 工具版本: `BaiduPCS-Go v4.0.0`
- 本地保存目录: `/root/autodl-tmp/baidu_dl`
- 最终网盘路径: `/MNIST/temp/分层分组（按骨面型）已整好1520✖️1236`

## 执行记录
1. 检查并安装 `BaiduPCS-Go`，软链到 `/usr/local/bin/BaiduPCS-Go`。
2. 创建下载目录并完成配置:
   - `config set -savedir /root/autodl-tmp/baidu_dl`
   - `config set -max_parallel 15 -max_download_load 2`
3. 使用 Cookie 登录后，已通过 `BaiduPCS-Go who` 和 `BaiduPCS-Go quota` 验证账号状态。
4. 路径定位:
   - 先尝试 `/MNIST/temp/分层分组（按骨面型`，返回不存在。
   - 通过 `/MNIST/temp` 列表定位到最终路径 `/MNIST/temp/分层分组（按骨面型）已整好1520✖️1236`。
5. 下载执行与续跑:
   - 首次 `locate` 模式出现进程 `panic` 中断。
   - 按规则尝试过 `--mode pcs` 续跑（可续传）。
   - 自查后使用 `GODEBUG=netdns=cgo` + `locate` 模式续跑完成（自动跳过已下载文件）。

## 验收结果
- 文件总数: `1605`
- 总大小: `2.1G` (`2207160698` bytes)
- 分组统计:
  - `训练集`: 1200 文件
  - `验证集`: 200 文件
  - `测试集`: 200 文件
  - 根目录清单文件: 5 文件（`README.txt`、`data.csv`、`train_ids.csv`、`val_ids.csv`、`test_ids.csv`）
- 失败项:
  - 最终完成轮次无失败项，未发现残留临时下载文件。

## 可复现/中断续跑命令
```bash
# 续跑命令（重复执行会自动跳过已下载文件）
GODEBUG=netdns=cgo BaiduPCS-Go d "/MNIST/temp/分层分组（按骨面型）已整好1520✖️1236" \
  --saveto /root/autodl-tmp/baidu_dl --status
```

