# TEST_POLICY

## 1. 目的

このドキュメントは、本リポジトリにおけるテストコード実装方針を定義する。
本リポジトリは学習・検証用途の Rails アプリであり、単純な CRUD だけでなく以下の検証テーマを含む。

- Form Object による複数モデル更新
- 並び替えロジック
- CSV / ZIP 出力
- 外部 API 呼び出し
- Active Storage を伴うネストフォーム
- Action Mailer と Sidekiq の利用

そのため、一般的なテスト観点に加えて、上記の実装特性に対する回帰防止を重視する。

## 2. テストフレームワークと利用 Gem

### 2.1 基本方針

- テストフレームワークは rspec を使用する。
- 既存の設定に合わせ、`spec/rails_helper.rb` と `spec/spec_helper.rb` を基点に実装する。

### 2.2 利用する既存 Gem（テスト実装で積極利用）

- rspec-rails: 単体・リクエスト・システムテストの実装基盤
- factory_bot_rails: テストデータ生成
- faker: ランダムデータ生成（重複しやすい値は sequence 併用）
- shoulda-matchers: バリデーション/関連の簡潔な検証
- simplecov: カバレッジ可視化
- capybara + selenium-webdriver + webdrivers: ブラウザ操作を伴う system spec

### 2.3 必要に応じて利用する既存 Gem

- devise: 認証を要する画面/機能のテストでヘルパーを使用
- sidekiq: 非同期ジョブの enqueue 検証（必要に応じて ActiveJob の test adapter と使い分け）
- typhoeus: 外部 API クライアントの呼び出し境界でスタブ対象にする

## 3. テスト対象の優先順位

### 3.1 優先度 High（先に整備）

- Model / Form Object のバリデーション・保存トランザクション
- Request spec による主要ユースケース（成功系・失敗系）
- 既存の複雑ロジック
  - Post の sort_priority 更新
  - FoodForm の save/update 分岐
  - ComicGenreForm の save/update 分岐
  - Tweet 画像関連のネストフォーム制御

### 3.2 優先度 Medium

- メール送信・ジョブ投入の検証
- API エンドポイント（postal code search）のレスポンス整形
- CSV/ZIP 出力のヘッダ・内容・レスポンス属性

### 3.3 優先度 Low

- 見た目中心の system spec（導線の確認に限定し、過剰に増やさない）

## 4. レイヤー別テスト方針

## 4.1 Model spec

対象:

- ActiveRecord モデル（Post, Area, Food, Tweet, TweetImage, TweetTag など）
- Form Object（FoodForm, ComicGenreForm）
- 外部 API 呼び出しラッパ（PostalCodeSearch）

観点:

- バリデーション（必須、acceptance、関連整合）
- コールバック（Post の sort_priority 採番/再採番）
- トランザクションのロールバック
- 複数レコード更新時の整合性

実装ルール:

- 単純な関連/バリデーションは shoulda-matchers で簡潔に記述する。
- ドメインロジック（条件分岐、並び替え、destroy 分岐）は通常の example で振る舞いを明示する。
- 外部通信は実行しない。必ずスタブまたはモック化する。

## 4.2 Request spec

対象:

- posts, comics, areas, areas/foods, tweets, api/postal_code_search

観点:

- 正常系: ステータス、リダイレクト、レスポンス本文、DB 変更
- 異常系: バリデーションエラー時の再描画とデータ不整合がないこと
- 副作用: メール送信、ジョブ投入、ファイル出力

実装ルール:

- 1 example 1期待値群を基本にし、意図の異なる検証は context を分ける。
- HTML の断片一致だけでなく、DB 変更や assign される値の妥当性を検証する。

## 4.3 System spec

対象:

- JavaScript 依存の操作がある画面（必要最小限）
  - Post 並び替え導線
  - ネストフォーム入力の基本導線

観点:

- ユーザーが主要機能を完了できるか
- JavaScript 有効時の最低限の回帰確認

実装ルール:

- 件数は絞り、壊れやすい E2E を過剰に増やさない。
- 仕様確認は request/model で担保し、system は導線確認に集中する。

## 5. このリポジトリ固有の重点観点

### 5.1 Posts（並び替え・出力・メール）

- sort アクションで oldIndex/newIndex が同値の場合に変更されないこと
- 前後移動で中間要素の sort_priority が正しく再配置されること
- csv_export でヘッダとデータ順が期待通りであること
- zip_export で zip 形式リクエスト時のみ出力されること
- send_sample_mail / send_now_sample_mail のリダイレクトと送信呼び出し

### 5.2 FoodForm（複数レコード編集）

- consent 未同意時に保存失敗しロールバックされること
- name/price 空時の destroy 分岐
- update 時に id 不正値が来ても意図しない更新をしないこと
- tags 更新を含むトランザクション整合性

### 5.3 ComicGenreForm

- Comic と Genre の同時保存成功/失敗
- update 時の genre id ごとの更新整合
- バリデーション失敗時に部分保存されないこと

### 5.4 Tweets（ネストフォーム + Active Storage）

- title/text/accept の基本バリデーション
- 画像未添付時の挙動
- バリデーションエラー時に set_tweet_image が実行される分岐
- tweet_tags, tweet_image の nested attributes 更新

### 5.5 PostalCodeSearch（外部 API）

- postal_code 空入力で空ハッシュを返すこと
- 正常レスポンス時に先頭結果を返すこと
- results なしレスポンスで空ハッシュを返すこと
- リクエスト層ではモデル戻り値を正しく描画に反映すること

## 6. テストデータ方針

- 生成は factory_bot を標準とする。
- 複数件データは create_list を優先する。
- 一意制約や比較が必要な項目は sequence を定義して不安定化を防ぐ。
- Active Storage の添付は fixture ファイルを再利用する。

## 7. モック・スタブ方針

- 外部 HTTP 通信は必ずスタブ化する。
- メールは ActionMailer::Base.deliveries もしくは matcher で検証する。
- 非同期実行は「ジョブが積まれたこと」を基本に検証し、実処理の詳細はジョブ/メール側で検証する。

## 8. カバレッジ運用

- simplecov で全体カバレッジを計測する。
- 数値目標は固定しすぎず、以下を必達とする。
  - 変更したクラス/エンドポイントの主要分岐をテスト済み
  - 回帰しやすいロジック（Form Object、並び替え、外部 API 境界）を未検証で残さない

## 9. 命名・記述規約

- describe: クラス/メソッド単位で責務を明確化
- context: 前提条件（正常系/異常系/境界値）
- it: 期待する振る舞いを日本語で具体的に表現
- 期待値は 1 example で過密にしすぎず、失敗時に原因が分かる粒度に分割する

## 10. 実行コマンド

- 事前起動（初回または停止中の場合）: `docker compose up -d app db redis`
- 全体実行: `docker compose exec app bundle exec rspec`
- モデルのみ: `docker compose exec app bundle exec rspec spec/models`
- リクエストのみ: `docker compose exec app bundle exec rspec spec/requests`
- 特定ファイル: `docker compose exec app bundle exec rspec spec/models/food_form_spec.rb`

必要時:

- カバレッジ付き実行: `docker compose exec -e COVERAGE=true app bundle exec rspec`

## 11. 追加実装ガイド（現状との差分埋め）

現状、spec はモデル中心で request が限定的なため、以下の順で拡張する。

1. posts の request spec を追加（sort/csv/zip/mail）
2. areas/foods の request spec を追加（Form Object 経由の create/update）
3. tweets の request spec を追加（バリデーションエラー時分岐を含む）
4. api/postal_code_search の request spec を追加
5. 必要最小限の system spec を追加

以上を本リポジトリの標準テスト実装方針とする。
