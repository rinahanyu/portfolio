module SignInModule
  def sign_in_as(user)
    visit new_user_session_path
    fill_in 'user[email]', with: 'h@h'
    fill_in 'user[password]', with: 'password'
    click_button 'ログイン'
  end

  def family_registration(user, hospital)
    user.medical_relationships.create(hospital_id: hospital.id)
  end

  def sign_in_as(hospital)
    visit new_hospital_session_path
    fill_in 'hospital[email]', with: 's@s'
    fill_in 'hospital[password]', with: 'password'
    click_button 'ログイン'
  end
end