class ChangeStoryToEpisode < ActiveRecord::Migration
  def up
    rename_table :stories, :episodes
  end

  def down
    rename_table :episodes, :stories
  end
end
