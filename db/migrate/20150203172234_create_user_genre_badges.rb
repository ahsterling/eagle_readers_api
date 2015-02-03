class CreateUserGenreBadges < ActiveRecord::Migration
  def change
    create_table :user_genre_badges do |t|
      t.integer :user_id
      t.integer :genre_badge_id

      t.timestamps null: false
    end
  end
end
