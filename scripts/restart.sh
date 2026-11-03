#!/bin/bash
# 时间记录器 - 重启服务(保持开机自启 + 崩溃自动重启)
# 用法: sudo ./scripts/restart.sh

set -e
cd "$(dirname "$0")"

SERVICE="time-logger"
UNIT_SRC="./${SERVICE}.service"
UNIT_DST="/etc/systemd/system/${SERVICE}.service"

if [ "$(id -u)" -ne 0 ]; then
  echo "[错误] 需要 root 权限, 请执行: sudo $0"
  exit 1
fi

if [ ! -f "$UNIT_SRC" ]; then
  echo "[错误] 缺少服务配置文件: $(pwd)/${SERVICE}.service"
  exit 1
fi

install -m 644 "$UNIT_SRC" "$UNIT_DST"
systemctl daemon-reload
systemctl enable "$SERVICE" >/dev/null 2>&1
systemctl restart "$SERVICE"

sleep 1
if systemctl is-active --quiet "$SERVICE"; then
  echo "服务已重启, 已开启开机自启与崩溃自动重启 (restart=always)"
  echo "状态: systemctl status $SERVICE"
else
  echo "[失败] 服务未能启动, 查看日志: journalctl -u $SERVICE -n 30"
  exit 1
fi
