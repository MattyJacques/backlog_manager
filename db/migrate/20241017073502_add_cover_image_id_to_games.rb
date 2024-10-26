# frozen_string_literal: true

class AddCoverImageIdToGames < ActiveRecord::Migration[7.1]
  def up
    add_column :games, :image_id, :string
  end

  def down
    remove_column :games, :igdb_cover_id
  end
end
