class ChangeNameForCutParts < ActiveRecord::Migration
  def up
    rename_column :cut_parts, :order, :sort
  end

  def down
    rename_column :cut_parts, :sort, :order
  end
end
