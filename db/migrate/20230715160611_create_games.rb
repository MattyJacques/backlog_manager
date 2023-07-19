class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name, null: false
      t.integer :igdb_id, index: { unique: true, name: 'unique game IGDB ID index' }
      t.integer :how_long_to_beat_id, index: { unique: true, name: 'unique game HLTB ID index' }

      t.timestamps
    end
  end
end
