class AddLocNumberToBook < ActiveRecord::Migration
  def change
    add_column :books, :loc_number, :string
  end
end
