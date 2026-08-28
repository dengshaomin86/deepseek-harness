#!/usr/bin/env bash

# 1. 加载当前用户的环境变量（解决 NVM / pnpm 环境变量未载入问题）
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc"
fi

# 1. 显式追加 Node 和 pnpm 的实际安装路径到环境变量 PATH 中
export PATH="/home/dsm/.local/share/pnpm/bin:$PATH"

# 1. 确保工作目录始终切换到脚本所在的根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "📂 工作目录已锁定在: $SCRIPT_DIR"

# 2. 校验 pnpm 是否存在
if ! command -v pnpm &> /dev/null; then
    echo "❌ 错误: 未检测到 pnpm，请先安装 pnpm。"
    exit 1
fi

# 3. 捕获中断信号（Ctrl+C），确保优雅退出
trap 'echo -e "\n🛑 正在停止 DeepSeek Harness Web 服务..."; exit 0' INT TERM

echo "🚀 正在启动 DeepSeek Harness Web 面板..."
echo "--------------------------------------------------"

# 4. 执行启动命令
pnpm dsh web "$@"
