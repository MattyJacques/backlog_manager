# frozen_string_literal: true

class GameStatus < ApplicationRecord
  enum status: { wishlist: 1, backlog: 2, ready_to_play: 3, playing: 4,
                 beaten: 5, completed: 6, shelved: 7, abandoned: 8 }

  belongs_to :user
  belongs_to :game
end
