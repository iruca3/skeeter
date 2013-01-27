class RenameTableForStoryMember < ActiveRecord::Migration
  def up
    rename_column :episodes, :episode, :episode_number
    rename_table :story_members, :episode_members
  end

  def down
    rename_column :episodes, :episode_number,:episode
    rename_table :episode_members, :story_members
  end
end
