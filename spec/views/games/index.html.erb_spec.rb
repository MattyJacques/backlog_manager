# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/index' do
  let(:games) { [build(:game), build(:game)] }

  before do
    assign(:games, games)
  end

  it 'renders a list of games' do
    render

    assert_select 'tr>td', text: games[0].name
    assert_select 'tr>td', text: games[1].name
  end
end
