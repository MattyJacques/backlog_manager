# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User signs out' do
  it 'when user is signed in' do
    user = create(:user)

    sign_in(user)

    visit root_path

    find('.profile-dropdown').click
    click_button 'Sign out'

    expect(page).to have_text 'Signed out successfully.'
    expect(page).not_to have_selector '.profile-dropdown'
    expect(page).to have_current_path root_path
  end
end
