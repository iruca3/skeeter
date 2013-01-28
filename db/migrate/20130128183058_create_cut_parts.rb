class CreateCutParts < ActiveRecord::Migration
  def change
    create_table :cut_parts do |t|
      t.string       :name

      t.timestamps
    end
  end
end
