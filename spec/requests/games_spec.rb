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

  describe 'PATCH /update' do
    context 'when user is signed in' do
      let(:user) { User.create!(email: 'testing@email.com', username: 'Tester123', password: 'password123') }
      let(:game_status) { instance_double(GameStatus, status:) }
      let(:status) { 'ready_to_play' }

      before do
        allow(Game).to receive(:find).with(best_game.id).and_return(best_game)
        allow(GameStatus).to receive(:find_or_initialize_by).with(game_id: best_game.id, user_id: user.id)
                                                            .and_return(game_status)
        allow(best_game).to receive(:status_for_user).with(user.id).and_return(game_status)
        allow(second_best_game).to receive(:status_for_user).with(user.id).and_return(nil)
      end

      it 'returns http success and updates game' do
        expect(game_status).to receive(:update!).with(status:)

        sign_in(user)
        patch game_url(id: best_game.id, status:)

        expect(response).to have_http_status(:success)
      end
    end
  end
end
