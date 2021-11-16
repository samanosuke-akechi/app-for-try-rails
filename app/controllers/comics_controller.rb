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

  def edit
    @comic = Comic.find(params[:id])
    if @comic.genres.count < 3
      (3 - @comic.genres.count).times do
        Genre.create(comic_id: @comic.id)
      end
      @genres = @comic.genres
    else
      @genres = @comic.genres
    end
  end

  def update
    @comic = Comic.find(params[:id])
    if @comic.update(comic_params)
      genre_params.keys.each do |id|
        genre = Genre.find(id)
        genre.update(name: genre_params[id][:name])
      end
      redirect_to action: :index
    else
      render :edit
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
