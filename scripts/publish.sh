#!/bin/bash
# 把干净公开版导出到一个独立公开仓库的工作副本。
# 用法: scripts/publish.sh <公开仓库路径>
# 公开白名单之外的一切（docs/ 内部文档、精读笔记、决策记录）永不导出。
set -e
DEST="${1:?用法: scripts/publish.sh <公开仓库路径>}"
[ -d "$DEST/.git" ] || { echo "错误: $DEST 不是一个 git 仓库（公开版必须是独立新建的仓库）"; exit 1; }

PUBLIC=(skills README.md CONTEXT.md LICENSE)

for p in "${PUBLIC[@]}"; do
  [ -e "$p" ] || continue
  rm -rf "${DEST:?}/$p"
  cp -r "$p" "$DEST/$p"
done

echo "已导出: ${PUBLIC[*]} → $DEST"
echo "下一步: cd $DEST && git add -A && git commit && git push"
