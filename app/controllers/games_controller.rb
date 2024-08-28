# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update destroy]
  before_action :set_session_filters, only: %i[index]

  # GET /games or /games.json
  def index
    @games = Game.includes(:platforms)
                 .then { search_by_name _1 }
                 .then { filter_by_platform _1 }
                 .then { apply_order _1 }
  end

  # GET /games/1 or /games/1.json
  def show; end

  # GET /games/search or /games/search.json
  def search
    @games = search_igdb(params[:search])
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit; end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: t('.success') }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to game_url(@game), notice: t('.success') }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy!

    respond_to do |format|
      format.html { redirect_to games_url, notice: t('.success') }
      format.json { head :no_content }
    end
  end

  private

  def search_by_name(scope)
    session['filters']['name'].present? ? scope.where('name like ?', "%#{session['filters']['name']}%") : scope
  end

  def filter_by_platform(scope)
    if session['filters']['platform'].present?
      scope.where(platforms: { id: session['filters']['platform'] })
    else
      scope
    end
  end

  def apply_order(scope)
    scope.order(session['filters'].slice('order', 'direction').values.join(' '))
  end

  def search_igdb(game_name)
    game_name.present? ? IGDB::Client::Games.search(game_name) : []
  rescue IGDB::Client::Errors::NotFound
    []
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  def set_session_filters
    session['filters'] ||= {}
    session['filters'].merge!(filter_params)

    Rails.logger.debug { "Filters: #{session['filters']}" }
  end

  # Only allow a list of trusted parameters through.
  def game_params
    params.require(:game).permit(:name, :igdb_id)
  end

  def filter_params
    params.permit(:name, :platform, :order, :direction)
  end
end
