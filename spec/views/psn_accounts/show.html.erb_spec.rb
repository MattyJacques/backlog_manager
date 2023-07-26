# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'psn_accounts/show.html.erb' do
  after { Capybara.reset_sessions! }

  before do
    assign(:account, PSNAccount.new(psn_id: 'Hakoom'))
    assign(:trophy_lists, [
             {
               id: 1,
               name: 'Trophy Clicker',
               detail: 'Click for trophies!',
               comm_id: 'NPWR12345_00',
               progress: '46/46',
               trophy_count: 46,
               bronze_count: 30,
               silver_count: 10,
               gold_count: 5,
               platinum_count: 1
             },
             {
               id: 2,
               name: 'Trophy Clicker 2',
               detail: 'Back by popular demand!',
               comm_id: 'NPWR12346_00',
               progress: '460/460',
               trophy_count: 460,
               bronze_count: 300,
               silver_count: 100,
               gold_count: 59,
               platinum_count: 1
             }
           ])
  end

  it 'renders a list of PSN accounts' do
    render

    expect(rendered).to have_selector('tr>td', text: 'Trophy Clicker')
    expect(rendered).to have_selector('tr>td', text: 'NPWR12345_00')
    expect(rendered).to have_selector('tr>td', text: '46/46')
    expect(rendered).to have_selector('tr>td', text: '46')
    expect(rendered).to have_selector('tr>td', text: '30')
    expect(rendered).to have_selector('tr>td', text: '10')
    expect(rendered).to have_selector('tr>td', text: '5')
    expect(rendered).to have_selector('tr>td', text: '1')
    expect(rendered).to have_selector('tr>td', text: 'Trophy Clicker 2')
    expect(rendered).to have_selector('tr>td', text: 'NPWR12346_00')
    expect(rendered).to have_selector('tr>td', text: '460/460')
    expect(rendered).to have_selector('tr>td', text: '300')
    expect(rendered).to have_selector('tr>td', text: '100')
    expect(rendered).to have_selector('tr>td', text: '59')
    expect(rendered).to have_selector('tr>td', text: '1')
  end
end
