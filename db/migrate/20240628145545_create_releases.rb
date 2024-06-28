# frozen_string_literal: true

class CreateReleases < ActiveRecord::Migration[7.1]
  def change
    create_table :releases do |t|
      t.belongs_to :game, null: false, foreign_key: true
      t.references :platform, null: false, foreign_key: true
      t.integer :region
      t.date :date
      t.integer :igdb_id, null: false, index: { unique: true, name: 'unique release igdb_id' }

      t.timestamps
    end
  end
end
