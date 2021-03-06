require 'rails_helper'

RSpec.feature 'Sign up', type: :feature do
  scenario 'shows sign-up page with email/password prompt' do
    visit '/'
    expect(page).to have_selector('#user_email')
    expect(page).to have_selector('#user_password')
  end

  scenario 'not logged in user redirected to login page' do
    visit('/posts')
    expect(page).to have_current_path('/users/sign_in')
    expect(page).to have_selector('#user_email')
    expect(page).to have_selector('#user_password')
  end

  scenario 'user can sign up' do
    sign_up_correct_helper
    expect(find('.notice')).to have_content('Welcome! You have signed up successfully.')
  end

  context 'when User signs up' do
    before { sign_up_correct_helper }

    scenario 'redirect to profile' do
      expect(page).to have_current_path('/testname')
    end

    scenario 'shows logout button' do
      expect(page).to have_selector('#log-out')
    end

    scenario 'user can log out' do
      click_on('Logout')
      expect(find('.notice')).to have_content('Signed out successfully.')
    end
  end

  scenario 'user sign up raises error when name is blank' do
    sign_up_no_name_helper
    expect(page).to have_content("Name can't be blank")
  end

  scenario 'sign up raises error when email invalid' do
    sign_up_helper('test@test', 'test', 'test123')
    expect(page).to have_content('Email is invalid')
  end

  context 'existing user' do
    before do
      sign_up_correct_helper
      click_on('Logout')
    end

    scenario 'can sign in' do
      log_in('test@email.com', 'Testing123')
      expect(find('.notice')).to have_content('Signed in successfully.')
    end

    scenario 'cannot sign in if password wrong' do
      log_in('test@email.com', 'password')
      expect(find('.alert')).to have_content('Invalid Email or password.')
    end
  end
end
