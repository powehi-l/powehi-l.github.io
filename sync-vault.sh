#!/usr/bin/env bash
# sync-vault.sh — 同步 Obsidian 知识库(公开部分)到 MkDocs 站点 docs/obsidian/
#
# 规则：
#   - 源: /opt/data/Obsidian Vault
#   - 目标: /opt/data/publish-repo/docs/obsidian/
#   - 排除: 日记/ (私人,不公开), 语音/ (音频文件), .obsidian (配置)
set -euo pipefail

VAULT="/opt/data/Obsidian Vault"
DEST="/opt/data/publish-repo/docs/obsidian"

echo "═══════════════════════════════════════════"
echo " 同步 Obsidian 知识库 → MkDocs 站点"
echo " 源   : $VAULT"
echo " 目标 : $DEST"
echo " 排除 : 日记/, 语音/, .obsidian"
echo "═══════════════════════════════════════════"

# 1. 清理旧目标
rm -rf "$DEST" && mkdir -p "$DEST"

# 2. 用 tar 管道同步，干净地排除私人目录(子 shell 也能正确工作)
cd "$VAULT"
tar \
  --exclude='日记' \
  --exclude='语音' \
  --exclude='.obsidian' \
  --exclude='.trash' \
  -cf - . | ( cd "$DEST" && tar xf - )

echo ""
echo "已同步内容:"
find "$DEST" -type f | sed "s|$DEST/|  |" | sort
echo ""
echo "同步完成 ✅"
