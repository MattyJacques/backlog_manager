# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Games' do
  let(:best_game) do
    instance_double(Game, id: 1, name: 'Best Game', platforms: [ps3])
  end
  let(:second_best_game) do
    instance_double(Game, id: 2, name: 'Second Best Game', platforms: [ps4])
  end
  let(:ps3) do
    instance_double(Platform, id: 1, abbreviation: 'PS3')
  end
  let(:ps4) do
    instance_double(Platform, id: 2, abbreviation: 'PS4')
  end
  let(:games) { [best_game, second_best_game] }

  before do
    allow(Game).to receive(:filter).and_return(games)
  end

  describe 'GET /index' do
    it 'returns http success' do
      get games_url

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /list' do
    it 'returns http success' do
      get list_games_url

      expect(response).to have_http_status(:success)
    end
  end
end
