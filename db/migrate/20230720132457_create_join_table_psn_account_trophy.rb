class CreateJoinTablePSNAccountTrophy < ActiveRecord::Migration[7.0]
  def change
    create_join_table :psn_accounts, :trophies, table_name: :earned_trophies do |t|
      t.index %i[psn_account_id trophy_id], unique: true, name: 'unique join account trophies'
      t.datetime :earned_timestamp
    end
  end
end
