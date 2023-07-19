class CreatePSNAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :psn_accounts do |t|
      t.string :psn_id, index: { unique: true, name: 'unique PSN ID' }
      t.string :account_id
      t.string :avatar
      t.boolean :plus, null: false, default: false
      t.text :about_me

      t.timestamps
    end
  end
end
