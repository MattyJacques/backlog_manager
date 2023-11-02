# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Games' do
  let(:game1) { build(:game, :trophies) }
  let(:game2) { build(:game, :trophies) }
  let(:games) { [game1, game2] }

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
      let(:game) { build(:game, game_statuses: [game_status]) }
      let(:user) { create(:user) }
      let(:game_status) { build(:game_status, :wishlist, user:) }
      let(:status) { 'ready_to_play' }

      before do
        allow(Game).to receive(:find).with(game.id).and_return(game)
        allow(GameStatus).to receive(:find_or_initialize_by).with(game_id: game.id, user_id: user.id)
                                                            .and_return(game_status)
      end

      it 'returns http success and updates game' do
        expect(game_status).to receive(:update!).with(status:)

        sign_in(user)
        patch game_url(id: game.id, status:)

        expect(response).to have_http_status(:success)
      end
    end
  end
end
