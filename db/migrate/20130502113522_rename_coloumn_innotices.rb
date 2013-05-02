class RenameColoumnInnotices < ActiveRecord::Migration
  def change
   rename_column :notices, :board_id, :noticeboard_id 
  end
end
