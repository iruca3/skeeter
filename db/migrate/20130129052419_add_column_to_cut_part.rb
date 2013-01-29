class AddColumnToCutPart < ActiveRecord::Migration
  def change
    add_column :cut_parts, :episode_id, :integer
  end
end
