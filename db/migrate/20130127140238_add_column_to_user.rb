class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter, :string
    add_column :users, :pixiv, :string
  end
end
