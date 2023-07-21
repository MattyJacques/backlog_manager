class CreateAccountTrophyLists < ActiveRecord::Migration[7.0]
  def change
    create_table :account_trophy_lists do |t|
      t.belongs_to :psn_account, null: false, foreign_key: true
      t.belongs_to :trophy_list, null: false, foreign_key: true

      t.timestamps

      t.index %i[psn_account_id trophy_list_id], unique: true, name: 'unique join account trophy lists'
    end
  end
end
