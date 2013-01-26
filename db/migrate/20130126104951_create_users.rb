class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string       :login_id
      t.string       :password
      t.string       :mail_addr
      t.string       :nick_name
      t.string       :real_name
      t.string       :account_type
      t.string       :account_status
      t.string       :last_login
      t.string       :phone_number

      t.timestamps
    end
  end
end
