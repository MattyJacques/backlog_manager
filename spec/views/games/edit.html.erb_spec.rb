# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/edit' do
  let(:game) do
    Game.create!(
      name: 'MyString'
    )
  end

  before do
    assign(:game, game)
  end

  it 'renders the edit game form' do
    render

    assert_select 'form[action=?][method=?]', game_path(game), 'post' do
      assert_select 'input[name=?]', 'game[name]'
    end
  end
end
