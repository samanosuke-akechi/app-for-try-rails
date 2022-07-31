class ComicGenreForm
  include ActiveModel::Model
  GENRE_NUM = 3
  attr_accessor :comic, :genres

  # form_withでPOSTとPATCHを判断するのに必要
  delegate :persisted?, to: :comic

  with_options presence: true do
    validates :comic
  end

  def initialize(params = [], comic_id: nil)
    if params.present? && comic_id.nil?
      self.comic = Comic.new(params['comic'])
      self.genres = params['genres'].map { |genre| Genre.new(genre) }
    else
      self.comic = Comic.find_or_initialize_by(id: comic_id)
      self.genres = self.comic.persisted? ? self.comic.genres : GENRE_NUM.times.map { Genre.new }
    end
  end

  def save
    ActiveRecord::Base.transaction do
      result = comic.save

      genres.each do |genre|
        genre.comic = comic
        result &= genre.save
      end

      # 意図的にrollback返さないとバリデーションに引っかかったところ以外が保存される
      raise ActiveRecord::Rollback unless result
      result
    end
  end

  def update(params)
    ActiveRecord::Base.transaction do
      result = comic.update(params['comic'])

      genres.each do |genre|
        result &= genre.update(params['genres'][genre.id.to_s])
      end

      raise ActiveRecord::Rollback unless result
      result
    end
  end
end
