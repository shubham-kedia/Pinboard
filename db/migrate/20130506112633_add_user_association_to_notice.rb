class AddUserAssociationToNotice < ActiveRecord::Migration
  def change
  	remove_column :notices , :author
  	add_column :notices , :user_id , :integer
  	add_index :notices , :user_id
  end
end
