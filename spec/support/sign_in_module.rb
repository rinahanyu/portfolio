module SignInModule
  def sign_in_as(user)
    visit new_user_session_path
    fill_in 'user[email]', with: 'h@h'
    fill_in 'user[password]', with: 'password'
    click_button 'ログイン'
    def current_user
      user
    end
  end

  def family_registration(user, hospital)
    user.medical_relationships.create(hospital_id: hospital.id)
  end

  def sign_in_as_hospital(hospital)
    visit new_hospital_session_path
    fill_in 'hospital[email]', with: 's@s'
    fill_in 'hospital[password]', with: 'password'
    click_button 'ログイン'
  end

  def patients?(user, hospital)
    hospital.medical_relationships.find_by(user_id: user.id).present?
  end
end