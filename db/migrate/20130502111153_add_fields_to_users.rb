class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :color, :string
    add_column :users, :gender, :string
    add_column :users, :contact_no, :string
  end
end
