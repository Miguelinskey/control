class ReplaceAdminWithRoleOnUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :role, :string, default: "member", null: false
    execute "UPDATE users SET role = 'administrator' WHERE admin = 1"
    remove_column :users, :admin
  end

  def down
    add_column :users, :admin, :boolean, default: false
    execute "UPDATE users SET admin = 1 WHERE role = 'administrator'"
    remove_column :users, :role
  end
end
