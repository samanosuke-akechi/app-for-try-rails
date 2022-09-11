class ComicsController < ApplicationController
  def index
    @comics = Comic.all.includes(:genres).order(created_at: :desc)
    ENV.fetch('GOOGLE_MAP_API_KEY')
  end

  def new
    @comic_genre = ComicGenreForm.new
  end

  def create
    @comic_genre = ComicGenreForm.new(comic_genre_params)
    if @comic_genre.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    @comic_genre = ComicGenreForm.new(comic_id: params[:id])
  end

  def update
    @comic_genre = ComicGenreForm.new(comic_genre_params, comic_id: params[:id])
    if @comic_genre.update(comic_genre_params)
      redirect_to comics_path
    else
      render :edit
    end
  end

  private

  def comic_genre_params
    params.require(:comic_genre).permit(comic: [:title, :author], genres: :name)
  end
end
