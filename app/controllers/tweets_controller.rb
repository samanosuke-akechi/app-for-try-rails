class TweetsController < ApplicationController
  before_action :set_tweet, only: [:new, :create, :edit, :update]
  before_action :set_tweet_image, only: [:new, :edit]

  def index
    @tweets = Tweet.all.includes(
      :tweet_tags, tweet_image: [storage_file_attachment: :blob]
    )
  end

  def new; end

  def create
    @tweet.assign_attributes(tweet_params)
    if @tweet.save
      redirect_to action: :index
    else
      set_tweet_image
      render :new
    end
  end

  def edit; end

  def update
    if @tweet.update(tweet_params)
      redirect_to action: :index
    else
      set_tweet_image
      render :edit
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(
      :title,
      :text,
      :accept,
      tweet_image_attributes: [:id, :_destroy, :storage_file],
      tweet_tags_attributes: [:id, :_destroy, :name]
    )
  end

  # バリデーションエラー時に画像が保存されず保存しようとした画像ファイルもformからリセットされてしまい、画像プレビューが表示できない
  # 解決方法としては二つ考えられる
  # 非同期処理にしてjsでページ遷移のコントロールをする、またはActiveStorageのダイレクトアップロード機能を使う
  def set_tweet
    @tweet = params[:id] ? Tweet.find(params[:id]) : Tweet.new
  end

  # 画像のパラメーターなしの時にcreateとupdateアクションの前に発動するとbuild_tweet_imageによって空のtweet_imageが作成される
  # (accepts_nested_attributes_forのreject_ifオプションを指定してもbuildしてしまうとレコードが作成されてしまう)
  # よってバリデーションエラー時のelseの分岐時だけrenderの前で発動させている
  def set_tweet_image
    @tweet_image = @tweet.tweet_image.nil? ? @tweet.build_tweet_image : @tweet.tweet_image
  end
end
