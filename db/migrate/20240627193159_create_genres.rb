# frozen_string_literal: true

class CreateGenres < ActiveRecord::Migration[7.1]
  def change
    create_table :genres do |t|
      t.string :name, index: { unique: true, name: 'unique genre name' }
      t.string :slug, index: { unique: true, name: 'unique genre slug' }
      t.integer :igdb_id, null: false, index: { unique: true, name: 'unique genre igdb_id' }

      t.timestamps
    end
  end
end
