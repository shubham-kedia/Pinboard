class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :images, :img
      t.references :notice
      t.timestamps
    end
  end
end
