# frozen_string_literal: true

class AddIGDBIdToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :igdb_id, :integer
    add_index :games, :igdb_id, unique: true, name: 'unique game igdb_id'
  end
end
