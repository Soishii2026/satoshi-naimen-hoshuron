#!/usr/bin/env bash
# PreToolUse ガード（調査ワークスペース用）
# Bash ツール実行前に呼ばれ、危険なコマンドをブロックする。
# 入力: stdin に JSON（tool_input.command にコマンド文字列）
# 出力: exit 0 = 許可 / exit 2 = ブロック（stderr のメッセージが Claude に返る)
#
# 注意: この Hook は Claude Code 経由の操作のみを縛る。手動操作や他ツールは
# GitHub 側の branch protection（三層目）で防ぐこと。

set -u

command=$(python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)

block() {
  echo "guard.sh: ブロックしました — $1" >&2
  exit 2
}

# 1. main への push / 強制 push の禁止（公開はサトシさん承認後、専用ブランチから）
if echo "$command" | grep -Eq 'git\s+push'; then
  echo "$command" | grep -Eq '(--force|-f\b)' && block "強制 push は禁止です"
  echo "$command" | grep -Eq '\b(main|master)\b' && block "main への直接 push は禁止です（PR経由・人間承認後のみ）"
  block "push はサトシさんの承認後に手動または明示許可で行ってください"
fi

# 2. sources/（原資料・読み取り専用領域）への書き込み・削除の禁止
if echo "$command" | grep -Eq '(^|[;&|]\s*)(rm|mv|cp|tee|sed\s+-i|truncate|>)\s' ; then
  echo "$command" | grep -q 'sources/' && block "sources/ は読み取り専用です"
fi
echo "$command" | grep -Eq 'rm\s+(-[a-zA-Z]*r[a-zA-Z]*f|-[a-zA-Z]*f[a-zA-Z]*r)' && block "rm -rf は禁止です"

# 3. RESTRICTED / CONFIDENTIAL ファイルの外部送信につながるコマンドの禁止
if echo "$command" | grep -Eq '\b(curl|wget|scp|rsync|nc|ftp)\b'; then
  block "外部送信コマンドは禁止です（監査パッケージはファイル生成→手動アップロード）"
fi

exit 0
