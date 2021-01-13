require 'rails_helper'

describe "医療関係者関連テスト" do
  let!(:hospital) {FactoryBot.create(:hospital)}
  let!(:user) {FactoryBot.create(:user)}
  let!(:medical_record) {FactoryBot.create(:medical_record, user: user, hospital: hospital)}

  describe 'マイページ（詳細）画面' do
    before do
      family_registration(user, hospital)
      sign_in_as_hospital(hospital)
      visit hospital_path(hospital)
    end

    context '表示の確認' do
      it '医療機関情報が表示されているか' do
        expect(page).to have_content hospital.name
        expect(page).to have_content hospital.telphone_number
        expect(page).to have_content hospital.postal_code
        expect(page).to have_content hospital.address
      end

      it '患者情報が表示されているか' do
        expect(page).to have_content user.last_name
        expect(page).to have_content user.telphone_number
        expect(page).to have_content user.postal_code
        expect(page).to have_content user.address
      end

      it '編集へのリンクが表示されているか' do
        expect(page).to have_link('編集する', href: '/hospitals/' + hospital.id.to_s + '/edit')
      end

      it '患者ページ・診療記録へのリンクが表示されているか' do
        expect(page).to have_link('患者ページ', href: '/users/' + user.id.to_s)
        expect(page).to have_link('診療記録', href: '/users/' + user.id.to_s + '/medical_records')
      end
    end

    context '動作の確認' do
      it '編集リンクの遷移先確認' do
        hospital_edit_link = find_all('a')[7]
        hospital_edit_link.click
        expect(page).to have_current_path edit_hospital_path(hospital)
      end

      it '患者ページのリンク遷移先確認' do
        patient_link = find_all('a')[8]
        patient_link.click
        expect(page).to have_current_path user_path(user)
      end

      it '診療記録のリンク遷移先確認' do
        medical_record_link = find_all('a')[9]
        medical_record_link.click
        expect(page).to have_current_path user_medical_records_path(user)
      end
    end
  end

  describe '編集画面' do
    before do
      sign_in_as_hospital(hospital)
      visit edit_hospital_path(hospital)
    end

    context '表示の確認' do
      it '編集前の内容が表示されている' do
        expect(page).to have_field 'hospital[name]', with: '赤十字病院'
        expect(page).to have_field 'hospital[address]', with: '広島県'
        expect(page).to have_field 'hospital[email]', with: 's@s'
        expect(page).to have_field 'hospital[telphone_number]', with: 000000000000
        expect(page).to have_field 'hospital[postal_code]', with: 00000000
      end

      it '更新ボタンが表示される' do
        expect(page).to have_button '編集する'
      end
    end

    context '動作の確認' do
      it '更新に成功しサクセスメッセージが表示されるか' do
        fill_in 'hospital[name]', with: '赤十字病院あ'
        fill_in 'hospital[address]', with: '広島県あ'
        fill_in 'hospital[email]', with: 's@s'
        fill_in 'hospital[telphone_number]', with: 000000000000
        fill_in 'hospital[postal_code]', with: 00000000
        click_button '編集する'
        expect(page).to have_content '更新しました'
      end

      it '更新に失敗しエラーメッセージが表示されるか' do
        fill_in 'hospital[name]', with: ''
        fill_in 'hospital[address]', with: ''
        fill_in 'hospital[email]', with: ''
        fill_in 'hospital[telphone_number]', with: ''
        fill_in 'hospital[postal_code]', with: ''
        click_button '編集する'
        expect(page).to have_content '医療機関名を入力してください'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content '郵便番号は数値で入力してください'
        expect(page).to have_content '住所を入力してください'
        expect(page).to have_content '電話番号は数値で入力してください'
      end

      it '更新後のリダイレクト先は正しいか' do
        fill_in 'hospital[name]', with: '赤十字病院あ'
        fill_in 'hospital[address]', with: '広島県あ'
        fill_in 'hospital[email]', with: 's@s'
        fill_in 'hospital[telphone_number]', with: 000000000000
        fill_in 'hospital[postal_code]', with: 00000000
        click_button '編集する'
        expect(page).to have_current_path hospital_path(hospital)
      end
    end
  end


  describe '新規登録画面' do
    before do
      visit new_hospital_registration_path
    end

    context '表示の確認' do
      it "投稿フォームが表示される" do
        expect(page).to have_content '新規登録（医療関係者さま）'
        expect(page).to have_field 'hospital[name]'
        expect(page).to have_field 'hospital[address]'
        expect(page).to have_field 'hospital[email]'
        expect(page).to have_field 'hospital[telphone_number]'
        expect(page).to have_field 'hospital[postal_code]'
        expect(page).to have_field 'hospital[password]'
        expect(page).to have_field 'hospital[password_confirmation]'
      end

      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録処理に関するテスト' do
      it '投稿に成功しサクセスメッセージが表示されるか' do
        fill_in 'hospital[name]', with: '神奈川病院'
        fill_in 'hospital[address]', with: '神奈川県'
        fill_in 'hospital[email]', with: 'k@k'
        fill_in 'hospital[telphone_number]', with: 000000000000
        fill_in 'hospital[postal_code]', with: 00000000
        fill_in 'hospital[password]', with: 'password'
        fill_in 'hospital[password_confirmation]', with: 'password'
        click_button '新規登録'
        expect(page).to have_content 'アカウント登録が完了しました'
      end

      it '新規登録に失敗する' do
        click_button '新規登録'
        expect(page).to have_content '医療機関名を入力してください'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content '郵便番号は数値で入力してください'
        expect(page).to have_content '住所を入力してください'
        expect(page).to have_content '電話番号は数値で入力してください'
        expect(page).to have_content 'パスワードを入力してください'
        expect(current_path).to eq('/hospitals')
      end

      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'hospital[name]', with: '神奈川病院'
        fill_in 'hospital[address]', with: '神奈川県'
        fill_in 'hospital[email]', with: 'k@k'
        fill_in 'hospital[telphone_number]', with: 000000000000
        fill_in 'hospital[postal_code]', with: 00000000
        fill_in 'hospital[password]', with: 'password'
        fill_in 'hospital[password_confirmation]', with: 'password'
        click_button '新規登録'
        expect(page).to have_current_path hospital_path(2)
      end
    end
  end

  describe 'ログイン画面' do
    before do
      visit new_hospital_session_path
    end

    context '表示の確認' do
      it "投稿フォームが表示される" do
        expect(page).to have_content 'ログイン（医療関係者さま）'
        expect(page).to have_field 'hospital[email]'
        expect(page).to have_field 'hospital[password]'
      end

      it '新規登録ボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン処理に関するテスト' do
      it 'ログインに成功しサクセスメッセージが表示されるか' do
        fill_in 'hospital[email]', with: 's@s'
        fill_in 'hospital[password]', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'ログインしました'
      end

      it 'ログインに失敗する' do
        click_button 'ログイン'
        expect(page).to have_content 'メールアドレスまたはパスワードが違います'
        expect(current_path).to eq('/hospitals/sign_in')
      end

      it 'ログイン後のリダイレクト先は正しいか' do
        fill_in 'hospital[email]', with: 's@s'
        fill_in 'hospital[password]', with: 'password'
        click_button 'ログイン'
        expect(page).to have_current_path hospital_path(hospital)
      end
    end
  end

  describe '医療機関一覧画面' do
    before do
      (1..4).each do |i|
        FactoryBot.create(:hospital, name: '医療機関名テスト'+ i.to_s, address: '住所テスト'+ i.to_s, email: 't@t'+ i.to_s,
        postal_code: 0000000, telphone_number: 00000000000)
      end
      sign_in_as_hospital(hospital)
      visit hospitals_path
    end

    context '表示の確認' do
      it '題名・かかりつけ医の医療機関名・電話番号・郵便番号・住所が表示されているか' do
        Hospital.all.each_with_index do |hospital|
          expect(page).to have_content '医療機関一覧'
          expect(page).to have_content hospital.name
          expect(page).to have_content hospital.telphone_number
          expect(page).to have_content hospital.postal_code
          expect(page).to have_content hospital.address
        end
      end

      it '医療機関詳細へのリンクが表示されているか' do
        Hospital.all.each_with_index do |hospital|
          expect(page).to have_link(hospital.name, href: '/hospitals/' + hospital.id.to_s)
        end
      end
    end

    context '動作の確認' do
      it '医療機関一覧リンクの遷移先確認' do
        Hospital.all.each_with_index do |hospital, i|
          hospital_show_link = find_all('a')[7 + i]
	        expect(hospital_show_link[:href]).to eq hospital_path(hospital)
	      end
      end
    end
  end
end