class ComicsController < ApplicationController
  def index
    @comics = Comic.all
  end

  def new
    @comic = Comic.new
    @genres = ComicGenreForm.new
  end

  def create
    @comic = Comic.new(comic_params)
    @genres = ComicGenreForm.new
    if @comic.save
      @genres.save(genre_params, @comic.id)
      redirect_to action: :index
    else
      render :new
    end
  end

  private

  def comic_params
    params.require(:comic).permit(:title, :author)
  end

  def genre_params
    params.require(:genres)
  end
end
