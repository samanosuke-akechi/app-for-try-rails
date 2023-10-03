require 'csv'

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
    csv_string = CSV.generate do |csv|
      csv << %w[title text]
      posts.each { |post| csv << [post.title, post.text] }
    end
    send_data(csv_string, filename: "posts_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv")
  end
end
