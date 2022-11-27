class Post < ApplicationRecord
  after_create :save_sort_priority

  def save_sort_priority
    lowest_priority = Post.maximum(:sort_priority)
    self.sort_priority = lowest_priority.nil? ? 0 : lowest_priority + 1
    save
  end

  def self.reset_sort_priority
    num = 0
    order(:id).each do |post|
      post.update(sort_priority: num)
      num += 1
    end
  end

  def update_sort_priority(old_index, new_index)
    return if old_index == new_index

    sort_range = (old_index - new_index).negative? ? old_index..new_index : new_index..old_index
    index_change = (old_index - new_index).negative? ? -1 : 1
    posts = Post.where(sort_priority: sort_range)

    posts.each do |post|
      next if post.sort_priority == old_index

      post.sort_priority = post.sort_priority + index_change
      post.save
    end

    self.sort_priority = new_index
    save
  end
end
