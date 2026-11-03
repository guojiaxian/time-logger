#!/bin/bash
# 时间记录器 - 完全停止服务(停止进程并取消开机自启)
# 用法: sudo ./scripts/stop.sh

set -e
cd "$(dirname "$0")"

SERVICE="time-logger"

if [ "$(id -u)" -ne 0 ]; then
  echo "[错误] 需要 root 权限, 请执行: sudo $0"
  exit 1
fi

systemctl stop "$SERVICE" 2>/dev/null || true
systemctl disable "$SERVICE" >/dev/null 2>&1 || true

if systemctl is-active --quiet "$SERVICE"; then
  echo "[失败] 服务仍在运行, 请检查: systemctl status $SERVICE"
  exit 1
fi

echo "服务已完全停止, 并已取消开机自启与自动重启"
echo "如需重新启动: sudo ./scripts/start.sh"
