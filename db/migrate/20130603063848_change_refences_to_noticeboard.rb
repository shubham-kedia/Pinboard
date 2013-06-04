class ChangeRefencesToNoticeboard < ActiveRecord::Migration
  def up
  	remove_column :noticeboards, :user_id
  	add_column :noticeboards, :board_id, :integer
  	add_column :noticeboards, :board_type, :string
  end

  def down
  	add_column :noticeboards, :user_id, :integer
  	remove_column :noticeboards, :board_id
  	remove_column :noticeboards, :board_type
  end
end
