# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/index' do
  before do
    Game.skip_callback(:create, :after, :import_igdb_data)

    assign(:games, [Game.create!(name: 'Game 1'), Game.create!(name: 'Game 2')])
  end

  after do
    Game.set_callback(:create, :after, :import_igdb_data)
  end

  it 'renders a list of games' do
    render

    assert_select 'tr>td', text: 'Game 1'
    assert_select 'tr>td', text: 'Game 2'
  end
end
