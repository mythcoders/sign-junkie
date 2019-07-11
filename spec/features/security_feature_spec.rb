# frozen_string_literal: true

RSpec.describe 'the signin process', type: :feature do
  feature 'signing in' do
    let(:user) { create(:customer, password: 'yodawg!') }

    it 'signs me in' do
      visit 'users/sign_in'
      fill_in 'user_email',	with: user.email
      fill_in 'user_password',	with: 'yodawg!'

      click_button 'Log in'
      expect(page).to have_content 'Signed in successfully'
    end
  end
end
