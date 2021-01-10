module SignInModule
  def sign_in_as(user)
    visit new_user_session_path
    fill_in 'user[email]', with: 'h@h'
    fill_in 'user[password]', with: 'password'
    click_button 'ログイン'
  end
end