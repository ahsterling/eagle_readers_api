class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.text :description
      t.date :pub_date
      t.integer :pages
      t.string :isbn
      t.string :subject_array, array: true, default: []

      t.timestamps null: false
    end
  end
end
