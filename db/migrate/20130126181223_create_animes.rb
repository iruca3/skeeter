class CreateAnimes < ActiveRecord::Migration
  def change
    create_table :animes do |t|
      t.integer       :owner_id
      t.string        :title
      t.integer       :story_number
      t.text          :description

      t.timestamps
    end
  end
end
