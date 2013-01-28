class ChangeColumnForEpisodeMembers < ActiveRecord::Migration
  def up
    rename_column :episode_members, :story_id, :episode_id
  end

  def down
    rename_column :episode_members, :episode_id, :story_id
  end
end
