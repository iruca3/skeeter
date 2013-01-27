class CreateStoryMembers < ActiveRecord::Migration
  def change
    create_table :story_members do |t|
      t.integer     :user_id
      t.integer     :story_id
      t.integer     :role

      t.timestamps
    end
  end
end
