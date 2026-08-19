#!/bin/bash
# 收工护栏：停笔超过 20 分钟且账本落后于正文时提醒一次，其余时候静默
[ -f ledger/promises.md ] || exit 0
f=$(ls -t manuscript/*.md manuscript/*/*.md 2>/dev/null | head -1)
[ -n "$f" ] || exit 0
if [ "$f" -nt ledger/promises.md ] && [ -n "$(find "$f" -mmin +20 2>/dev/null)" ]; then
  echo "提醒：$f 之后尚未收工（收割+交接+存档），请运行收工（wrap）。"
fi
exit 0
