# 政治コラム制作パイプライン仕様 v2.1（最終合意版）

Claude Code を主工程、GPT-5.6 Sol を外部監査役、Grok を公開反応シミュレーター（任意）
とする三層構造の制作パイプライン。GPT-5.6 Sol 側との協議で基本合意した最終版。

- 制定日: 2026-07-12
- 本ディレクトリはテンプレート置き場である。**実際の調査データ（sources/ research/
  drafts/ checks/ audits/）は必ず非公開ワークスペースに置き、この公開リポジトリには
  完成した公開用HTMLのみを置く。**

---

## 1. 役割分担

| 担当 | 役割 |
|---|---|
| Claude Code | 主工程。調査・台帳構築・ゲート判定・起草・トリアージ・機械検査・公開準備 |
| GPT-5.6 Sol | 外部監査役。A/B/C の3種監査のみ。工程には常駐しない |
| Grok（任意） | 公開前の世論・反論・切り取り耐性シミュレーション |
| サトシさん | ゲート承認、HUMAN_DECISION 指摘の裁定、公開の最終承認 |

原則: **起草者と監査者を別モデルにする。** GPT の価値は Claude の調査過程に
汚染されていない独立性にあるため、監査種別ごとに渡す情報を意図的に制限する。

## 2. 情報区分

すべての資料は取得時に次の区分を付ける。外部AI（GPT/Grok）への送信可否と連動する。

| 区分 | 内容 | 外部AIへの送信 |
|---|---|---|
| PUBLIC | 公開情報 | 可 |
| INTERNAL | 自分用資料・作業メモ | 必要部分のみ抜粋して可 |
| CONFIDENTIAL | 非公開情報・公開前原稿(案件による) | 原則禁止 |
| RESTRICTED | 個人情報・取材源情報 | 禁止 |

- ChatGPT 側の「Improve the model for everyone」は**運用開始前にオフを確認**する
  （ただしこれは補助策であり、区分規則が本体）。
- Temporary Chat を使う場合も PUBLIC 資料に限る。
- 監査パッケージには内部ファイルパス・取材源を含めない。個人名は必要に応じ匿名化。

## 3. 工程

### フル版（調査記事・重い論考）

| 段階 | 担当 | 内容 |
|---|---|---|
| 0 | サトシさん＋Claude Code | 情報区分・権限設定・公開範囲の確定 |
| 1 | サトシさん＋Claude Code | `00_brief.md`（問い・成功条件・停止条件） |
| 2 | Claude Code (Researcher) | 収集、`source_manifest.csv`、原文保存 |
| 3 | Claude Code (Evidence Auditor・別コンテキスト) | 命題と原資料の照合、`evidence_ledger.csv` |
| 4 | Evidence Auditor → **サトシさん承認** | GATE STATUS 判定（templates/gate_status_template.md） |
| 5 | Claude Code (Drafter) | `issue_map.md` → 段落ID付き原稿 |
| 6A | GPT | ブラインド論理監査（templates/audit_A_blind_logic.md） |
| 6B | GPT | 台帳整合性監査（templates/audit_B_ledger_consistency.md） |
| 6C | GPT | 外部事実クロスチェック（templates/audit_C_external_crosscheck.md） |
| 6D | Grok（任意） | 公開反応・反論シミュレーション |
| 7 | Claude Code | トリアージ（強制エスカレーション適用）、追加検証、改稿 |
| 8 | Claude Code | 機械検査（事実・引用・表記・リンク・ID除去） |
| 9 | Claude Code (Release Manager) | 公開ブランチで HTML/index/RSS 準備、diff 報告 |
| 10 | **サトシさん** | 最終承認 → push / 公開 |

### 軽量版（通常コラム）

簡易 brief → 収集・台帳（同一コンテキスト可）→ **ゲート判定のみ別コンテキスト＋
サトシさん承認** → 起草 → **GPT 鬼編集長（A監査）1往復** → トリアージ
（エスカレーション規則は適用）→ 機械検査 → サトシさん承認 → 公開。

**自動昇格規則（軽量版でも省略しない）:**

> 軽量版でも、高リスク命題が含まれる場合は、該当命題だけを対象とするミニC監査を
> 実施する。中心命題を左右する高リスク命題がある場合、または対象が3件以上ある
> 場合はフル版へ昇格する。

高リスク命題: 原稿の中心結論／数値／日付／現職者・役職／法的権限／直接引用／
政策の実行可能性／意図・因果関係に関する断定。

## 4. 監査体系

| 監査 | 名称 | 渡すもの | 渡さないもの | 判定語 |
|---|---|---|---|---|
| A | ブラインド論理監査 | 中心命題・原稿全文・想定媒体と字数 | 証拠台帳・調査メモ・判断理由 | 成立／軽微な修正が必要／重大な論理修正が必要／中心命題の再検討が必要 |
| B | 台帳整合性監査 | 原稿・事実命題一覧・対応表 | 原資料 | 整合／不整合あり |
| C | 外部事実クロスチェック | 原稿・高リスク命題・**PUBLIC区分の原資料抜粋**（証拠パケット形式） | CONFIDENTIAL/RESTRICTED資料 | 主要命題を確認／一部命題が未確認／重大命題が未確認／証拠間に重大な矛盾／**EVIDENCE_INSUFFICIENT** |

- C監査は原則「外部事実クロスチェック」と呼ぶ。GPT が独自に検索して一次資料まで
  到達した場合に限り「独立事実監査」と表記してよい。
- CONFIDENTIAL/RESTRICTED 資料に依拠する命題は GPT に出さず、サトシさん自身の
  確認事項として `audit_log.md` に残す。
- **どの監査にも「公開可」は判定させない。**

## 5. ID体系

- 起草時から段落ID `[P001]` と命題ID `[C014]` を付与し、**公開時に除去**する。
- GPT 指摘は固定形式（各監査テンプレート参照）: 指摘ID（例 A01-R003）／重要度
  （BLOCKER/MAJOR/MINOR）／種別／段落ID／命題ID／対象文／問題／外部検証要否／推奨処理。
- 監査ラウンドをまたいでも ID は変えない。

## 6. トリアージと強制エスカレーション

Claude Code は GPT 指摘を「採用／棄却／要追加調査」に分類するが、
**以下は Claude Code 単独で棄却できない**（`status: HUMAN_DECISION` として上げる）:

- 重大な事実誤認
- 中心命題を左右する出典欠落
- 法制度・権限の誤認
- 引用の不正確さ
- Claude と GPT で見解が分かれた因果関係
- 「要確認」とされた現職者・日付・数値

棄却時も、指摘ID・採否・判断理由・追加した証拠・参照 source_id・最終判断者・
判断日を `audit_log.md` に記録する（templates/audit_log_template.md）。

Grok から新しい事実が提示された場合は、そのまま採用せず必ず Evidence Auditor に
戻して出典確認する。

## 7. 「公開可」の成立条件（機械的判定）

どの AI も「公開可」を宣言しない。次の5条件が揃ったときのみ公開準備に進む:

1. BLOCKER 指摘が未処理ゼロ
2. 高リスク命題の全件に出典がある
3. 「未確認」分類の命題が確定表現になっていない
4. 機械検査（publish_checklist.md）を通過している
5. サトシさんの承認がある

## 8. 技術的強制の三層

| 層 | 手段 | 性質 |
|---|---|---|
| 指示層 | CLAUDE.md | 文脈。強制力なし |
| Claude Code 実行層 | permissions.deny ＋ PreToolUse Hook | Claude Code 経由の操作をブロック |
| リポジトリ層 | GitHub branch protection / ruleset | 最終防壁。手動操作・他ツールも縛る |

- 公開リポジトリの main には **branch protection（PR必須・直接push禁止）を
  GitHub 側で設定**する（リポジトリ Settings → Rules）。
- 導入時に**破壊的でない拒否テスト**を実施する:
  main への直接 push が拒否されるか／`sources/` への書き込みが拒否されるか／
  RESTRICTED ファイルの外部送信が止まるか／Hook 無効時に警告が出るか。

## 9. 運用開始前チェックリスト

- [ ] 非公開ワークスペースを作成し、`workspace/` 一式（CLAUDE.md・.claude/）をコピーした
- [ ] ChatGPT の「Improve the model for everyone」をオフにした
- [ ] 公開リポジトリの main に branch protection を設定した
- [ ] 拒否テスト4項目を実施した
- [ ] まずコラム1本を軽量版で通し、摩擦点を洗い出す

## ファイル構成

```
pipeline/
├─ README.md                       ← 本書（パイプライン仕様）
├─ publish_checklist.md            ← 公開リポジトリ用チェックリスト
├─ workspace/                      ← 非公開ワークスペースへコピーする一式
│  ├─ CLAUDE.md
│  └─ .claude/
│     ├─ settings.json             ← permissions.deny ＋ Hook 登録
│     └─ hooks/guard.sh            ← PreToolUse ガードスクリプト
└─ templates/
   ├─ 00_brief_template.md
   ├─ gate_status_template.md
   ├─ audit_A_blind_logic.md
   ├─ audit_B_ledger_consistency.md
   ├─ audit_C_external_crosscheck.md
   ├─ evidence_packet_template.md
   └─ audit_log_template.md
```
