# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/show' do
  before do
    assign(:game, Game.create!(
                    name: 'The Last of Us',
                    igdb_id: 26192
                  ))
  end

  it 'renders attributes in <p>' do
    render

    expect(rendered).to match(/The Last of Us/)
    expect(rendered).to match(/26192/)
  end
end
