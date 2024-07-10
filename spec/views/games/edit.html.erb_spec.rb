# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/edit' do
  let(:game) { create(:game) }

  before do
    Game.skip_callback(:create, :after, :import_igdb_data)

    assign(:game, game)
  end

  after do
    Game.set_callback(:create, :after, :import_igdb_data)
  end

  it 'renders the edit game form' do
    render

    assert_select 'form[action=?][method=?]', game_path(game), 'post' do
      assert_select 'input[name=?]', 'game[name]'
      assert_select 'input[name=?]', 'game[igdb_id]'
    end
  end
end
