class AddColumnToStory < ActiveRecord::Migration
  def change
    add_column :stories, :anime_id, :integer
  end
end
