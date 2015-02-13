class AddExplorerAttrToGenreBadge < ActiveRecord::Migration
  def change
    add_column :genre_badges, :explorer_badge, :boolean
  end
end
