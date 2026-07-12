# audit_log — ［案件名］

GPT/Grok 指摘のトリアージ記録。1指摘1ブロック。指摘IDはラウンドをまたいで不変。

## 強制エスカレーション規則（再掲）

以下は Claude Code 単独で棄却できない。`status: HUMAN_DECISION` としてサトシさんに上げる:
重大な事実誤認／中心命題を左右する出典欠落／法制度・権限の誤認／引用の不正確さ／
Claude と GPT で見解が分かれた因果関係／「要確認」とされた現職者・日付・数値。

Grok 由来の新事実は、そのまま採用せず必ず Evidence Auditor の出典確認に戻す。

---

## 記録形式

```
指摘ID: A01-R003
発信元: GPT-A監査 ／ GPT-B監査 ／ GPT-C監査 ／ Grok
重要度: BLOCKER / MAJOR / MINOR
status: 採用 ／ 棄却 ／ 要追加調査 ／ HUMAN_DECISION
判断理由: ［棄却の場合「原稿の方が正しい」だけの記載は不可。根拠を書く］
追加した証拠: ［あれば］
参照source_id: S-0XX
原稿への反映: ［draft_vX の P0XX をどう変えたか／変えなかったか］
最終判断者: Claude Code ／ サトシさん
判断日: YYYY-MM-DD
```

---

## 人間確認事項（外部AIに出せない命題）

CONFIDENTIAL/RESTRICTED 資料に依拠する高リスク命題はここに列挙し、
サトシさんが自身で原資料と照合する。

```
命題ID: C-0XX
命題: ［　］
依拠資料の区分: CONFIDENTIAL ／ RESTRICTED
確認状況: 未確認 ／ サトシさん確認済み（日付）
```

---

## 記録本体

（以下に追記）
