class AddTitleToGenreBadge < ActiveRecord::Migration
  def change
    add_column :genre_badges, :title, :string
    add_column :genre_badges, :bulk_badge, :boolean
    
  end
end
