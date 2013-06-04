class RemoveTeamIdFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :team_id
  end

  def down
  	add_column :users, :team_id, :integer
  end
end
