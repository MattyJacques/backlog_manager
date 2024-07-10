# frozen_string_literal: true

json.array! @games, partial: 'games/igdb_result', as: :game
