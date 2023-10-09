require 'csv'
require 'zip'

class PostsController < ApplicationController
  def index
    @posts = Post.order(:sort_priority).limit(10)
    @posts_limit10 = Post.all.limit(10)
    logger.info "Postのタイトル: #{@posts.first.title}" if @posts.present?
  end

  def google_map; end

  def sort
    post = Post.find_by(sort_priority: params[:oldIndex].to_i)
    post.update_sort_priority(params[:oldIndex].to_i, params[:newIndex].to_i)
  end

  def send_sample_mail
    SampleMailer.sample_notice('test@example.com').deliver_later
    redirect_to action: :index
  end

  def send_now_sample_mail
    SampleMailer.sample_notice('test@example.com').deliver_now
    redirect_to action: :index
  end

  def csv_export
    posts = Post.order(:sort_priority)
    csv_string = csv_generate(posts)
    send_data(csv_string, filename: "#{create_filename}.csv")
  end

  def zip_export
    redirect_to action: :index and return if request.format.symbol != :zip

    posts = Post.order(:sort_priority)
    filename = create_filename
    files = generate_csv_files(posts, filename)

    zip_filename = "#{filename}.zip"
    zip_generate(zip_filename, files)
    files.each { |f| File.delete(f) }
    send_data(File.read(zip_filename), filename: zip_filename)
    File.delete(zip_filename)
  end

  private

  # csv文字列の生成
  def csv_generate(posts)
    CSV.generate do |csv|
      csv << %w[title text]
      posts.each { |post| csv << [post.title, post.text] }
    end
  end

  def create_filename
    "posts_#{Time.current.strftime('%Y%m%d%H%M%S')}"
  end

  # csvファイルの生成
  def generate_csv_files(posts, filename)
    file = File.new("#{filename}.csv", 'w+')
    file.write(csv_generate(posts))

    file2 = File.new("#{filename}-2.csv", 'w+')
    file2.write(csv_generate(posts))
    [file, file2]
  end

  # zipファイルの生成
  def zip_generate(zip_filename, files)
    password = Zip::TraditionalEncrypter.new('password') # zipファイルのパスワード生成用インスタンス
    # password = nil
    Zip::OutputStream.open(zip_filename, password) do |out| # passwordがnilまたは引数なしの場合はパスワードなしで生成
      files.each do |file|
        out.put_next_entry(file.path) # zipファイルへの書き込み宣言。
        out.write(File.read(file)) # 上記で宣言したパスへの書き込み
      end
    end
  end
end
