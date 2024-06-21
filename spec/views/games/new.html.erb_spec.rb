# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/new' do
  before do
    assign(:game, Game.new(
                    name: 'MyString'
                  ))
  end

  it 'renders new game form' do
    render

    assert_select 'form[action=?][method=?]', games_path, 'post' do
      assert_select 'input[name=?]', 'game[name]'
    end
  end
end
