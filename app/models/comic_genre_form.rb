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
  
  def save
    Genre.create(name: name, comic_id: comic_id)
  end
end
