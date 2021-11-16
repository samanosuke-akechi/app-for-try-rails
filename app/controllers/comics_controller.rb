class ComicsController < ApplicationController
  def index
  end

  def new
    @comic = Comic.new
    @comic.genres.build
  end

  def create
    @comic = Comic.new(comic_params)
    genre = @comic.genres.build(genre_params)
    if @comic.save
      genre.save
      redirect_to action: :index
    else
      render :new
    end
  end

  private

  def comic_params
    params.require(:comic).permit(:title, :author, genres_attributes: [:name])
  end

  def genre_params
    params.require(:genre).permit(:name)
  end
end
