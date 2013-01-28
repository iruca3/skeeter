class CreateCuts < ActiveRecord::Migration
  def change
    create_table :cuts do |t|
      t.integer     :episode_id
      t.string      :number
      t.integer     :cut_part_id
      t.string      :picture
      t.text        :memo

      t.timestamps
    end
  end
end
