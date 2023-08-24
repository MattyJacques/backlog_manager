# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/index.html.erb' do
  let(:best_game) do
    instance_double(Game, id: 1, name: 'Best Game', platforms: [ps3], game_statuses: [])
  end
  let(:second_best_game) do
    instance_double(Game, id: 2, name: 'Second Best Game', platforms: [ps4], game_statuses: [])
  end
  let(:ps3) do
    instance_double(Platform, id: 1, abbreviation: 'PS3')
  end
  let(:ps4) do
    instance_double(Platform, id: 2, abbreviation: 'PS4')
  end
  let(:best_game_status) { nil }

  before do
    assign(:games, [best_game, second_best_game])
  end

  context 'when no user is logged in' do
    it 'renders a list of games with no statuses' do
      render

      expect(rendered).to have_selector('tr>td', text: best_game.name)
      expect(rendered).to have_selector('tr>td', text: ps3.abbreviation)
      expect(rendered).not_to have_selector('tr>th', text: 'Status')
      expect(rendered).to have_selector('tr>td', text: second_best_game.name)
      expect(rendered).to have_selector('tr>td', text: ps4.abbreviation)
    end
  end

  context 'when a user is logged in' do
    let(:user) { User.create!(email: 'testing@email.com', username: 'Tester123', password: 'password123') }
    let(:best_game_status) { instance_double(GameStatus, status: :wishlist, user_id: user.id) }

    before do
      allow(best_game).to receive(:game_statuses).and_return([best_game_status])
    end

    it 'renders a list of games with statuses' do
      sign_in(user)
      render

      expect(rendered).to have_selector('tr>th', text: 'Status')
      expect(rendered).to have_selector('tr>td', text: best_game.name)
      expect(rendered).to have_selector('tr>td', text: ps3.abbreviation)
      expect(rendered).to have_selector('tr>td', text: best_game_status.status.to_s)
      expect(rendered).to have_selector('tr>td', text: second_best_game.name)
      expect(rendered).to have_selector('tr>td', text: ps4.abbreviation)
    end
  end
end
