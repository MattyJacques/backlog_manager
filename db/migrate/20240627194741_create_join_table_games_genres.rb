# frozen_string_literal: true

class CreateJoinTableGamesGenres < ActiveRecord::Migration[7.1]
  def change
    create_join_table :games, :genres do |t|
      t.index %i[game_id genre_id]
    end
  end
end
