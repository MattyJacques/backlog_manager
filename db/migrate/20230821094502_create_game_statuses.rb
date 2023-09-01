class CreateGameStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :game_statuses do |t|
      t.integer :status, null: false
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
