class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment
      t.references :user
      t.references :notice

      t.timestamps
    end
  end
end
