# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User signs up' do
  it 'with valid data' do
    visit new_user_registration_path

    fill_in 'user_username', with: 'ToxicTesting'
    fill_in 'user_email', with: 'username@example.com'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    fill_in 'user_psn_account_attributes_psn_id', with: 'SuperCoolPSNID'
    click_button 'Sign up'

    expect(page).to have_text 'Welcome! You have signed up successfully.'
    expect(page).to have_selector '.profile-dropdown'
    expect(page).to have_current_path root_path
  end

  it 'with invalid data' do
    visit new_user_registration_path

    click_button 'Sign up'

    expect(page).to have_text 'Username can\'t be blank'
    expect(page).to have_text 'Email can\'t be blank'
    expect(page).to have_text 'Password can\'t be blank'
    expect(page).not_to have_selector '.profile-dropdown'
  end
end
