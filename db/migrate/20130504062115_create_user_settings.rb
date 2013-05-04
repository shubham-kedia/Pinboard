class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.string :notice_visibility
      t.string :date_visibility
      t.string :auto_delete
      t.references :user

      t.timestamps
    end
    add_index :user_settings, :user_id
  end
end
