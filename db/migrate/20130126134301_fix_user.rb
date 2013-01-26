class FixUser < ActiveRecord::Migration
  def up
    remove_column :users, :last_login
    add_column :users, :last_login, :datetime
    remove_column :users, :account_type
    add_column :users, :account_type, :integer
    remove_column :users, :account_status
    add_column :users, :account_status, :integer
  end

  def down
    remove_column :users, :last_login
    add_column :users, :last_login, :string
    remove_column :users, :account_type
    add_column :users, :account_type, :string
    remove_column :users, :account_status
    add_column :users, :account_status, :string
  end
end
