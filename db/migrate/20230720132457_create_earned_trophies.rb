class CreateEarnedTrophies < ActiveRecord::Migration[7.0]
  def change
    create_table :earned_trophies do |t|
      t.belongs_to :account_trophy_list, null: false, foreign_key: true
      t.belongs_to :trophy, null: false, foreign_key: true
      t.datetime :timestamp

      t.timestamps

      t.index %i[account_trophy_list_id trophy_id], unique: true, name: 'unique account trophies'
    end
  end
end
