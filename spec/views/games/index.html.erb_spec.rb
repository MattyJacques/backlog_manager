# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/index.html.erb' do
  let(:game1) { build(:game_with_platform, :trophies) }
  let(:game2) { build(:game_with_platform, :trophies) }

  before do
    assign(:games, [game1, game2])
  end

  context 'when no user is logged in' do
    it 'renders a list of games with no statuses' do
      render

      expect(rendered).to have_selector('tr>td', text: game1.name)
      expect(rendered).to have_selector('tr>td', text: game1.platforms.first.abbreviation)
      expect(rendered).not_to have_selector('tr>th', text: 'Status')
      expect(rendered).to have_selector('tr>td', text: game2.name)
      expect(rendered).to have_selector('tr>td', text: game2.platforms.first.abbreviation)
    end
  end

  context 'when a user is logged in' do
    let(:user) { create(:user) }
    let(:game1_status) { build(:game_status, user:) }
    let(:game1) { build(:game_with_platform, :trophies, game_statuses: [game1_status]) }

    it 'renders a list of games with statuses' do
      sign_in(user)
      render

      expect(rendered).to have_selector('tr>th', text: 'Status')
      expect(rendered).to have_selector('tr>td', text: game1.name)
      expect(rendered).to have_selector('tr>td', text: game1.platforms.first.abbreviation)
      expect(rendered).to have_selector('tr>td', text: game1_status.status.to_s)
      expect(rendered).to have_selector('tr>td', text: game2.name)
      expect(rendered).to have_selector('tr>td', text: game2.platforms.first.abbreviation)
    end
  end
end
