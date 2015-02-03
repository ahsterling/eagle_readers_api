class CreateGenreBadges < ActiveRecord::Migration
  def change
    create_table :genre_badges do |t|
      t.string :genre_name
      t.text :description

      t.timestamps null: false
    end
  end
end
