class AddOrderColumnToCutPart < ActiveRecord::Migration
  def change
    add_column :cut_parts, :order, :integer
  end
end
