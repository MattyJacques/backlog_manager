# frozen_string_literal: true

class GamesController < ApplicationController
  include Filterable

  def index
    @games = filter!(Game)
  end

  def list
    games = filter!(Game)
    render(partial: 'games', locals: { games: })
  end
end
