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
      index = 0
      @genres.collection.each do |genre|
        genre.comic_id = @comic.id
        genre.name = genre_params[index][:name]
        genre.save
        index += 1
      end
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
