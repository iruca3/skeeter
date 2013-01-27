class ChangeColumnForAnime < ActiveRecord::Migration
  def up
    rename_column :animes, :story_number, :total_episode_number
  end

  def down
    rename_column :animes, :total_episode_number, :story_number
  end
end
