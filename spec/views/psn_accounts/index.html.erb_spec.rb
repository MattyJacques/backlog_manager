# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'psn_accounts/index.html.erb' do
  before do
    assign(:account_data, [
             {
               id: 1,
               psn_id: 'Hakoom',
               game_count: 10_000,
               platforms: 'PS3, PSVita, PS4, PS5',
               trophy_count: 100_000,
               bronze_count: 4000,
               silver_count: 3000,
               gold_count: 2000,
               platinum_count: 1000
             },
             {
               id: 2,
               psn_id: 'Roughdawg4',
               game_count: 10_001,
               platforms: 'PS3, PSVita, PS4, PS5',
               trophy_count: 100_010,
               bronze_count: 4004,
               silver_count: 3003,
               gold_count: 2002,
               platinum_count: 1001
             }
           ])
  end

  it 'renders a list of PSN accounts' do
    render

    expect(rendered).to have_selector('tr>td', text: 'Hakoom')
    expect(rendered).to have_selector('tr>td', text: '10000')
    expect(rendered).to have_selector('tr>td', text: 'PS3, PSVita, PS4, PS5')
    expect(rendered).to have_selector('tr>td', text: '100000')
    expect(rendered).to have_selector('tr>td', text: '4000')
    expect(rendered).to have_selector('tr>td', text: '3000')
    expect(rendered).to have_selector('tr>td', text: '2000')
    expect(rendered).to have_selector('tr>td', text: '1000')
    expect(rendered).to have_selector('tr>td', text: 'Roughdawg4')
    expect(rendered).to have_selector('tr>td', text: '10001')
    expect(rendered).to have_selector('tr>td', text: 'PS3, PSVita, PS4, PS5')
    expect(rendered).to have_selector('tr>td', text: '100010')
    expect(rendered).to have_selector('tr>td', text: '4004')
    expect(rendered).to have_selector('tr>td', text: '3003')
    expect(rendered).to have_selector('tr>td', text: '2002')
    expect(rendered).to have_selector('tr>td', text: '1001')
  end
end
