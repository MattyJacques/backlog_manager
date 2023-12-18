# frozen_string_literal: true

class GamesController < ApplicationController
  include Filterable

  def index
    @games = filter!(Game)
  end

  def search
    games = filter!(Game)
    render(partial: 'games', locals: { games: })
  end

  def update
    game = Game.find(game_params[:id].to_i)

    update_game_status(game)

    games = filter!(Game)
    render(partial: 'games', locals: { games: })
  end

  private

  def update_game_status(game)
    status = GameStatus.find_or_initialize_by(game_id: game.id, user_id: current_user.id)

    if game_params[:status].empty?
      status.destroy!
    else
      status.update!(status: game_params[:status])
    end
  end

  def game_params
    params.permit(:id, :status)
  end
end
