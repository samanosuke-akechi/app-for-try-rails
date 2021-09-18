class Hoge::PostsController < ApplicationController
  def index
    @posts = Post.all
  end
end
