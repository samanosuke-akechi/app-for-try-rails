# RESEARCH

調査日: 2026年5月12日

## 概要

このリポジトリは Ruby on Rails 7 系をベースにした検証用アプリケーションで、複数の Rails 機能を横断的に試す構成になっている。単一ドメインの業務アプリというより、CRUD、ネストフォーム、Active Storage、メール送信、Sidekiq、外部 API 呼び出し、CSV/ZIP 出力、JavaScript 連携などをまとめて確認できるサンプル兼学習用の性格が強い。

ルートは posts#index で、Posts、Comics、Areas/Foods、Tweets が主要機能として配置されている。README は雛形のままで、実運用向けの手順書よりもコードから理解する前提の状態にある。

## 技術スタック

### バックエンド

- Ruby 3.1.2
- Rails 7.0.4 系
- MySQL 5.7
- Puma
- Unicorn 本番用 gem を同梱
- Sidekiq 6 系未満
- Redis 4 系
- Jbuilder
- Gretel
- Typhoeus
- Active Storage

### フロントエンド

- importmap-rails ベース
- Stimulus
- Turbolinks
- jQuery を CDN pin で導入
- slick-carousel を CDN pin で導入
- SortableJS を CDN pin で導入
- stimulus-rails-nested-form を CDN pin で導入
- Sass

### 開発・テスト

- RSpec
- FactoryBot
- Faker
- byebug
- letter_opener_web
- RuboCop
- Docker / docker compose

## アプリケーション構成

### ルーティング

config/routes.rb では以下の機能群が公開されている。

- ルート: posts#index
- posts: index のほか、google_map、sort、send_sample_mail、send_now_sample_mail、csv_export、zip_export を collection action として提供
- comics: destroy 以外の標準 CRUD
- areas: 標準 CRUD
- areas 配下の単数 resource foods: Areas 名前空間の FoodsController に委譲
- api/postal_code_search/search: 郵便番号検索 API
- hoge/posts#index: 名前空間サンプル
- tweets: index/new/create/edit/update
- 開発環境のみ letter_opener
- Sidekiq Web UI

この構成から、単純な CRUD だけでなく、名前空間、ネスト resource、非同期処理、ファイル出力、外部 API 連携の練習用途が明確に読み取れる。

## 主要機能

### Posts

PostsController はこのアプリで最も機能の多いコントローラの一つで、一覧表示に加えて次の機能を持つ。

- sort_priority による並び順管理
- SortableJS と Ajax を使ったドラッグ並び替え
- CSV エクスポート
- ZIP エクスポート
- Action Mailer の即時送信と非同期送信の比較

Post モデルは before_create で sort_priority を採番し、after_destroy で再採番する。update_sort_priority で並び替え範囲の sort_priority を更新しているため、一覧 UI とモデルロジックが結びついた構成になっている。

ZIP 出力では rubyzip を使い、CSV を 2 ファイル生成して zip にまとめている。ZIP パスワードはコード上で固定値 password になっているため、検証用途としては成立する一方、実運用向けにはそのままでは使いづらい。

### Areas / Foods

AreasController は標準的な CRUD 構成で、Area を親に持つ Foods を Areas::FoodsController で編集する。ここでは単純な accepts_nested_attributes_for ではなく、FoodForm という Form Object を使って複数 Food をまとめて処理している。

FoodForm の特徴は以下の通り。

- ActiveModel::Model を利用
- 3 件固定の入力欄を前提に初期化
- consent の acceptance バリデーションをフォーム全体に持つ
- create/update を transaction で包む
- 行が空なら destroy、値があれば save するルールを実装
- tag_ids を受け取り、中間テーブル付きの更新を考慮して assign_attributes のタイミングに注意している

この領域は複数レコード同時編集とバリデーション/ロールバックの扱いを試すための実装と見られる。

### Comics

ComicsController は ComicGenreForm を使って Comic と Genre をまとめて扱う。フォームオブジェクトで親子テーブルを一括保存・更新する構成で、以下の特徴がある。

- Comic と複数 Genre を一つのフォームで処理
- delegate persisted? により form_with の create/update 判定に対応
- transaction を用いた複数テーブル保存
- update 時に genre.id をキーとして個別更新

コード中に、空の genres レコードが生成される課題を示す TODO が残っている。学習・検証用コードとして途中段階のメモが保持されている。

### Tweets

TweetsController と Tweet 系モデルは、ネストフォーム、Active Storage、acceptance バリデーションを組み合わせたサンプルになっている。

Tweet モデルの特徴は以下の通り。

- has_many tweet_tags
- has_one tweet_image
- accepts_nested_attributes_for を両方に設定
- tweet_image には reject_if: :storage_file_attached? を設定
- title と text を必須化
- accept に acceptance バリデーション

TweetsController では、バリデーションエラー時にファイル入力が失われる問題を考慮し、set_tweet_image の呼び出しタイミングを create/update 前ではなく render 前に限定している。コメントにも、非同期化または Active Storage の direct upload が代替案として記されている。

この領域は、画像アップロード付きネストフォーム実装時の落とし穴を意識した構成になっている。

### 郵便番号検索 API

Api::PostalCodeSearchController は PostalCodeSearch.search_to_typhoeus を利用し、zipcloud API から住所情報を取得する。モデル名は ActiveRecord 継承だが、実際の役割は API クライアント兼フォーム用モデルに近い。

PostalCodeSearch には 2 つの実装があり、以下を比較できる。

- net/http を使う search
- Typhoeus を使う search_to_typhoeus

コメントでは Typhoeus の方が速いと明示されている。

### メール送信

SampleMailer は sample_notice を持ち、メールテンプレートへ Hello World と Area 一覧を渡す。PostsController から deliver_now と deliver_later の両方を呼べるため、同期/非同期送信の違いを試せる。

開発環境では letter_opener_web を利用するため、ブラウザで送信内容を確認できる。

## データモデル

db/schema.rb から確認できる主要テーブルは以下の通り。

- posts
- comics
- genres
- areas
- foods
- tags
- food_tags
- tweets
- tweet_tags
- tweet_images
- Active Storage 関連テーブル一式

### 関連の概要

- Comic has_many Genres
- Area has_many Foods
- Food は Area に属し、FoodTag を介して Tag と関連
- Tweet has_many TweetTags
- Tweet has_one TweetImage
- TweetImage は Active Storage の attachment を持つ構成

Posts だけは他モデルとの関連よりも、一覧表示・エクスポート・並び替えのユースケース中心の設計である。

## JavaScript 構成

JavaScript は webpack や Vite ではなく importmap で管理されている。config/importmap.rb と app/javascript 配下から、次の利用が確認できる。

- application.js で jquery_init、try_slick、sortable、Stimulus controllers を読み込み
- try_slick.js で slick-carousel を初期化
- sortable.js で SortableJS と jQuery Ajax による並び替え更新を実装

CDN pin が多く、フロントエンドの依存管理は軽量である一方、Node ベースのビルドパイプラインは採用していない。workspace 直下に package.json は存在せず、Rails 7 の importmap 流儀に沿っている。

## 非同期処理・ジョブ実行

config/application.rb で Active Job の adapter は sidekiq に設定されている。config/sidekiq.yml では default と mailers キューが定義され、docker-compose.yml には sidekiq サービスが存在する。

config/initializers/sidekiq.rb では Redis の接続先を redis:6379 に設定している。compose 上でも redis サービス名が redis のため、コンテナ間通信としては整合している。

## 実行環境とインフラ

### Docker 構成

docker-compose.yml では以下の 4 サービス構成になっている。

- app: Rails サーバ
- db: MySQL 5.7
- sidekiq: 非同期ジョブ実行
- redis: Sidekiq 用 Redis

特徴は以下の通り。

- app は 3000 番ポート公開
- db は永続 volume を利用
- redis はホスト 6370 をコンテナ 6379 にマップ
- app と sidekiq は .env を読む前提
- app はソースコードを bind mount
- gem は gem_data volume に保持

Dockerfile は Ruby 3.1.2 ベースで、nodejs、vim、build-essential をインストールして bundle install を実行する標準構成。entrypoint.sh は server.pid を削除してからプロセスを起動する。

### 環境設定

- development: letter_opener_web を利用、Active Storage は local、DB host は db
- production: Active Storage は local のまま、assets.compile は false、DB password は環境変数参照
- time_zone は Tokyo

production でも Active Storage が local のままであり、クラウドストレージ前提の構成にはなっていない。

## テスト構成

RSpec が導入されており、spec/models、spec/requests、spec/factories が存在する。確認できた範囲では以下のテスト対象がある。

- Area
- Comic
- Food
- FoodForm
- PostalCodeSearch
- Tweet
- TweetImage
- TweetTag
- Comics の request spec
- Area 関連 request spec ディレクトリ

FactoryBot 用 factory も tweet、tweet_image、tweet_tag、foods、areas、comics、tags などが揃っている。アプリ全体に対して完全網羅ではないが、主要なモデル挙動と一部リクエストに対するテストは用意されている。

## コードベース上の特徴

### 学習・検証用途の性格が強い

以下の要素から、実務プロダクトよりも学習リポジトリの性格が強い。

- README が雛形のまま
- 1 リポジトリ内に複数テーマのサンプルが共存
- コメントが多く、実装意図や注意点を説明している
- namespace や nested resource を試すサンプルが含まれる
- deliver_now と deliver_later を同一画面から比較できる
- net/http と Typhoeus の両方式を同一クラスで保持している

### フォームオブジェクトの活用

ComicGenreForm と FoodForm により、複数モデルをまとめた保存/更新を明示的に制御している。Rails 標準の nested attributes に全面依存せず、transaction と条件分岐を自前で持つ構成であるため、フォーム処理の学習素材として価値が高い。

### コメントに実装上の論点が残されている

コードコメントには次のような論点が具体的に残っている。

- Active Storage のファイル入力がバリデーションエラー時に失われる問題
- reject_if と build の相互作用
- 中間テーブル更新時に assign_attributes のタイミングへ注意が必要なこと
- ComicGenreForm に空 Genre が作られる TODO

これらは現在の設計を理解する上で重要な補助情報になっている。

## 注意点・改善余地

調査ベースで気づく主な注意点は以下の通り。

- README が未整備で、セットアップや各機能の意図をコード読解に依存している
- ZIP パスワードが固定文字列でハードコードされている
- zip_export は一時ファイル作成と削除を手動で行っており、例外発生時の後始末に弱い
- ComicGenreForm に空 Genre レコード生成の TODO が残っている
- PostalCodeSearch は ActiveRecord 継承だが、責務としては API クライアント寄りであり、役割境界はやや曖昧
- production の Active Storage が local のままで、永続化/配布戦略は別途検討が必要
- package.json 不在のため、Node ベースの lint/build 前提で見ると構成を誤解しやすいが、実際は importmap 採用が正しい

## 総括

このリポジトリは、Rails の複数機能を現実的な最小構成で試すための実験場としてよくまとまっている。特に以下の観点で価値が高い。

- フォームオブジェクトによる複数モデル更新
- Active Storage を含むネストフォーム
- Sidekiq とメール送信の統合
- importmap + jQuery + Stimulus の混在運用
- CSV/ZIP 出力
- 外部 API 呼び出し

一方で、運用ドキュメントや本番向け安全性は限定的であり、実サービス化する場合は設定外出し、例外時の後始末、責務分離、ストレージ戦略、README 整備が優先課題になる。