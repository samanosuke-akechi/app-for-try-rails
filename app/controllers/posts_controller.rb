class PostsController < ApplicationController
  def index
    @posts = Post.all
    @posts_limit10 = Post.all.limit(10)
  end
end
