class CreateBookSubjects < ActiveRecord::Migration
  def change
    create_table :book_subjects do |t|
      t.string :book_id
      t.string :subject_id

      t.timestamps null: false
    end
  end
end
