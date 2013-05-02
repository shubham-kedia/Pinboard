class CreateNoticeboards < ActiveRecord::Migration
  def change
    create_table :noticeboards do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
