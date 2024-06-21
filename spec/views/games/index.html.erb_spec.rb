# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games/index' do
  before do
    assign(:games, [
             Game.create!(
               name: 'Name'
             ),
             Game.create!(
               name: 'Name'
             )
           ])
  end

  it 'renders a list of games' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Name'.to_s), count: 2
  end
end
