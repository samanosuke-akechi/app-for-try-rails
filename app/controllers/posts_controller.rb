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
end
