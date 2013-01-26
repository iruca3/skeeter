class AddColumnToAnime < ActiveRecord::Migration
  def change
    add_column :animes, :status, :integer
  end
end
