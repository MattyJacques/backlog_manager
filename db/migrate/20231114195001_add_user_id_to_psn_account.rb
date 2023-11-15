class AddUserIdToPSNAccount < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :psn_accounts, :users
  end
end
