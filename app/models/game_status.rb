# frozen_string_literal: true

class GameStatus < ApplicationRecord
  enum status: { wishlist: 0, backlog: 1, ready_to_play: 2, playing: 3,
                 beaten: 4, completed: 5, shelved: 6, abandoned: 7 }

  belongs_to :game
end
