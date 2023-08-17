# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/index.html.erb' do
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

  before do
    assign(:games, [best_game, second_best_game])
  end

  it 'renders a list of games' do
    render

    expect(rendered).to have_selector('tr>td', text: best_game.name)
    expect(rendered).to have_selector('tr>td', text: ps3.abbreviation)
    expect(rendered).to have_selector('tr>td', text: second_best_game.name)
    expect(rendered).to have_selector('tr>td', text: ps4.abbreviation)
  end
end
