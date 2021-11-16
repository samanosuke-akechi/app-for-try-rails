class ComicGenreForm
  include ActiveModel::Model
  GENRE_NUM = 3
  attr_accessor :collection

  with_options presence: true do
    validates :comic_id
  end

  def initialize(attributes = [])
    if attributes.present?
      self.collection = attributes.map do |value|
        Genre.new(
          name: value[:name]
        )
      end
    else
      self.collection = GENRE_NUM.times.map { Genre.new }
    end
  end

  def persisted?
    false
  end
  
  def save(genre_params, comic_id)
    index = 0
    collection.each do |genre|
      genre.comic_id = comic_id
      genre.name = genre_params[index][:name]
      genre.save
      index += 1
    end
  end
end
