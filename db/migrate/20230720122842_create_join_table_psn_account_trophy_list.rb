class CreateJoinTablePSNAccountTrophyList < ActiveRecord::Migration[7.0]
  def change
    create_join_table :psn_accounts, :trophy_lists, table_name: :account_trophy_lists do |t|
      t.index %i[psn_account_id trophy_list_id], unique: true, name: 'unique join account trophy lists'

      t.timestamps
    end
  end
end
