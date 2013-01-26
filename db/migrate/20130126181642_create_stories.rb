class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer      :director_id
      t.integer      :episode
      t.text         :title
      t.text         :description
      t.datetime     :deadline

      t.timestamps
    end
  end
end
