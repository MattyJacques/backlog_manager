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
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Name'.to_s), count: 2
  end
end
