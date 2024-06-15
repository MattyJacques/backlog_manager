# frozen_string_literal: true

class IGDBController < ApplicationController
  def index
    @games = IGDB::Client::Games.search(params[:search]) if params[:search].present?
  end
end
