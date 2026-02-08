class AddSignupIpToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :signup_ip, :string
  end
end
