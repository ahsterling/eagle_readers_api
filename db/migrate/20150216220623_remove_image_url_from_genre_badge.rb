class RemoveImageUrlFromGenreBadge < ActiveRecord::Migration
  def change
    remove_column :genre_badges, :image_url
  end
end
