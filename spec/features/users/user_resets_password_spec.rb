# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User resets a password' do
  it 'user enters a valid email' do
    user = create(:user)

    visit new_user_password_path

    fill_in 'user_email', with: user.email
    click_button 'Send me reset password instructions'

    expect(page).to have_text 'You will receive an email with instructions'
    expect(page).to have_current_path new_user_session_path
  end

  it 'user enters an invalid email' do
    visit new_user_password_path

    fill_in 'user_email', with: 'username@example.com'
    click_button 'Send me reset password instructions'

    expect(page).to have_text 'Email not found'
  end

  it 'user changes password' do
    token = create(:user).send_reset_password_instructions

    visit edit_user_password_path(reset_password_token: token)

    fill_in 'user_password', with: 'p4ssw0rd'
    fill_in 'user_password_confirmation', with: 'p4ssw0rd'
    click_button 'Change my password'

    expect(page).to have_text 'Your password has been changed successfully.'
    expect(page).to have_current_path root_path
  end

  it 'password reset token is invalid' do
    visit edit_user_password_path(reset_password_token: 'token')

    fill_in 'user_password', with: 'p4ssw0rd'
    fill_in 'user_password_confirmation', with: 'p4ssw0rd'
    click_button 'Change my password'

    expect(page).to have_text 'Reset password token is invalid'
  end
end
