class Post < ApplicationRecord
  after_create :save_sort_priority

  def save_sort_priority
    lowest_priority = Post.maximum(:sort_priority)
    self.sort_priority = lowest_priority + 1
    save
  end

  def self.reset_sort_priority
    num = 0
    order(:id).each do |post|
      post.update(sort_priority: num)
      num += 1
    end
  end

  def update_sort_priority(oldIndex, newIndex)
    return if oldIndex == newIndex

    sort_range = (oldIndex - newIndex) < 0 ? oldIndex..newIndex : newIndex..oldIndex
    index_change = (oldIndex - newIndex) < 0 ? -1 : 1
    posts = Post.where(sort_priority: sort_range)

    posts.each do |post|
      next if post.sort_priority == oldIndex

      post.sort_priority = post.sort_priority + index_change
      post.save
    end

    self.sort_priority = newIndex
    save
  end
end
