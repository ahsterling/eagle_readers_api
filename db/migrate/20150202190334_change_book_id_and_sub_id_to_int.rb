class ChangeBookIdAndSubIdToInt < ActiveRecord::Migration
  def change
    remove_column :book_subjects, :book_id
    remove_column :book_subjects, :subject_id
    add_column :book_subjects, :book_id, :integer
    add_column :book_subjects, :subject_id, :integer
  end
end
