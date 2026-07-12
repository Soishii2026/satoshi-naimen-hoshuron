# 証拠パケット（C監査添付用）

高リスク命題1件につき1ブロック。**PUBLIC区分の資料のみ**。内部ファイルパス・
取材源情報を含めない。個人名は必要に応じ匿名化する。

```
claim_id: C-014
draft_paragraph: P-006
draft_text: ［原稿中の該当文を逐語で］
classification: 推論（7分類のいずれか）
risk_level: 高
source_id: S-008
source_type: ［例: 中国商務部公式発表］
source_date: 2026-06-29
source_title_or_url: ［公開URL または 資料名。内部パス不可］
source_excerpt: ［原文または正確な訳文。抜粋であることを明示］
locator: ［例: 第3段落］
contradicting_source: S-012（あれば。同形式で抜粋を添付）
open_question: ［例: 撤退誘導という明示的表現は存在しない］
```

## 記入原則

- source_excerpt は原文の表記どおりに写す。要約・意訳を混ぜる場合は
  ［訳文］［要約］と明示する。
- 反証資料（contradicting_source）が台帳にある場合は必ず添付する。
  支持資料だけを選んで渡さない。
- CONFIDENTIAL/RESTRICTED 資料に依拠する命題はパケット化せず、
  audit_log.md に「人間確認事項」として記録する。
