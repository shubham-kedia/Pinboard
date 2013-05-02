class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :title
      t.text :content
      t.string :author
      t.string :access_type
      t.integer :board_id

      t.timestamps
    end
  end
end
