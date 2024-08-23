# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/games' do
  let(:game) { build(:game, id: 7) }
  let(:valid_attributes) { attributes_for(:game) }
  let(:invalid_attributes) { { igdb_id: 0 } }

  before do
    allow(IGDB::Services::ImportGame).to receive(:import)
  end

  describe 'GET /index' do
    context 'when there are no games' do
      it 'renders a successful response' do
        get games_url

        expect(response).to be_successful
      end
    end

    context 'when some games exist' do
      let(:games) { [game] }

      before do
        allow(Game).to receive(:includes).and_return(Game)
        allow(Game).to receive(:order).and_return(games)
      end

      it 'renders a successful response' do
        get games_url

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    before do
      allow(Game).to receive(:find).with('7').and_return(game)
    end

    it 'renders a successful response' do
      get game_url(game)

      expect(response).to be_successful
    end
  end

  describe 'GET /search' do
    context 'when format is HTML' do
      context 'when there is no search parameter' do
        it 'renders a successful response' do
          get search_games_url

          expect(response).to be_successful
        end
      end

      context 'when there is a search parameter' do
        before do
          allow(IGDB::Client::Games).to receive(:search).with('The Last of Us').and_return([game])
        end

        it 'renders a successful response' do
          get search_games_url(search: 'The Last of Us')

          expect(response).to be_successful
        end

        context 'when there is no game found' do
          before do
            allow(IGDB::Client::Games).to receive(:search).with('The Last of Us')
                                                          .and_raise(IGDB::Client::Errors::NotFound)
          end

          it 'renders a successful response' do
            get search_games_url(search: 'The Last of Us')

            expect(response).to be_successful
          end
        end
      end
    end

    context 'when format is JSON' do
      context 'when there is no search parameter' do
        it 'renders a successful response' do
          get search_games_url(format: :json)

          expect(response).to be_successful
        end
      end

      context 'when there is a search parameter' do
        before do
          allow(IGDB::Client::Games).to receive(:search).with('The Last of Us').and_return([game])
        end

        it 'renders a successful response' do
          get search_games_url(search: 'The Last of Us', format: :json)

          expect(response).to be_successful
        end
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_game_url

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    before do
      allow(Game).to receive(:find).with('7').and_return(game)
    end

    it 'renders a successful response' do
      get edit_game_url(game)

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'when format is HTML' do
      context 'with valid parameters' do
        it 'creates a new Game' do
          expect do
            post games_url, params: { game: valid_attributes }
          end.to change(Game, :count).by(1)
        end

        it 'redirects to the created game' do
          post games_url, params: { game: valid_attributes }
          expect(response).to redirect_to(game_url(Game.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Game' do
          expect do
            post games_url, params: { game: invalid_attributes }
          end.not_to change(Game, :count)
        end

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          post games_url, params: { game: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when format is JSON' do
      context 'with valid parameters' do
        it 'creates a new Game' do
          expect do
            post games_url(format: :json), params: { game: valid_attributes }
          end.to change(Game, :count).by(1)
        end

        it 'redirects to the created game' do
          post games_url(format: :json), params: { game: valid_attributes }

          expect(response.parsed_body.keys).to eq(Game.new.attributes.keys + ['url'])
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Game' do
          expect do
            post games_url(format: :json), params: { game: invalid_attributes }
          end.not_to change(Game, :count)
        end

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          post games_url(format: :json), params: { game: invalid_attributes }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PATCH /update' do
    let(:game) { create(:game) }

    context 'when format is HTML' do
      context 'with valid parameters' do
        let(:new_attributes) { { name: 'The Last of Us Part II', igdb_id: 26192 } }

        it 'updates the requested game' do
          patch game_url(game), params: { game: new_attributes }

          game.reload

          expect(game.name).to eql(new_attributes[:name])
        end

        it 'redirects to the game' do
          patch game_url(game), params: { game: new_attributes }

          expect(response).to redirect_to(game_url(game))
        end
      end

      context 'with invalid parameters' do
        it "renders a response with 422 status (i.e. to display the 'edit' template)" do
          patch game_url(game), params: { game: invalid_attributes }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when format is JSON' do
      context 'with valid parameters' do
        let(:new_attributes) { { name: 'The Last of Us Part II', igdb_id: 26192 } }

        it 'updates the requested game' do
          patch game_url(game, format: :json), params: { game: new_attributes }

          game.reload

          expect(game.name).to eql(new_attributes[:name])
        end

        it 'returns the all game attributes' do
          patch game_url(game, format: :json), params: { game: new_attributes }

          expect(response.parsed_body.keys).to eq(Game.new.attributes.keys + ['url'])
        end
      end

      context 'with invalid parameters' do
        it "renders a response with 422 status (i.e. to display the 'edit' template)" do
          patch game_url(game, format: :json), params: { game: invalid_attributes }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    before do
      game.save!
    end

    it 'destroys the requested game' do
      expect do
        delete game_url(game)
      end.to change(Game, :count).by(-1)
    end

    it 'redirects to the games list' do
      delete game_url(game)

      expect(response).to redirect_to(games_url)
    end
  end
end
