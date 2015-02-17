class AddImageToGenreBadges < ActiveRecord::Migration
  def change
    add_column :genre_badges, :image, :string
  end
end
