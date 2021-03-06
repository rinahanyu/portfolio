require 'rails_helper'

describe "個人利用者関連テスト" do
  let!(:user) {FactoryBot.create(:user)}
  let!(:user2) {FactoryBot.create(:user, email: 'h@h2')}
  let!(:hospital) {FactoryBot.create(:hospital)}
  let!(:hospital2) {FactoryBot.create(:hospital, email: 's@s2')}
  let!(:daily_record) {FactoryBot.create(:daily_record, user: user)}

  describe '個人利用者ログイン（本人）' do
    describe 'マイページ（詳細）画面' do
      before do
        sign_in_as(user)
        visit user_path(user)
      end

      context '表示の確認' do
        it '氏名が表示されているか' do
          expect(page).to have_content user.first_name
          expect(page).to have_content user.last_name
        end

        it '基本情報編集・退会ページへのリンクが表示されているか' do
          expect(page).to have_link('基本情報編集する', href: '/users/' + user.id.to_s + '/edit')
          expect(page).to have_link('退会手続きへ', href: '/users/' + user.id.to_s + '/delete_confirm')
        end

        it '病歴・健康管理・かかりつけ医の一覧へのリンクが表示されているか' do
          expect(page).to have_link('一覧へ', href: '/users/' + user.id.to_s + '/medical_histories')
          expect(page).to have_link('一覧へ', href: '/users/' + user.id.to_s + '/health_cares')
          expect(page).to have_link('一覧へ', href: '/users/' + user.id.to_s + '/families')
        end

        it '日常記録の題名・ジャンルが表示されているか' do
          expect(page).to have_content daily_record.theme
          expect(page).to have_content daily_record.genre
        end

        it '日常記録の新規投稿・詳細へのリンクが表示されているか' do
          expect(page).to have_link('新しく投稿する！', href: '/daily_records/new')
          expect(page).to have_link(daily_record.theme, href: '/daily_records/' + daily_record.id.to_s)
        end
      end

      context '動作の確認' do
        it '基本情報編集リンクの遷移先確認' do
          user_edit_link = find_all('a')[11]
          user_edit_link.click
          expect(page).to have_current_path edit_user_path(user)
        end

        it '退会ページのリンク遷移先確認' do
          delete_confirm_link = find_all('a')[12]
          delete_confirm_link.click
          expect(page).to have_current_path user_delete_confirm_path(user)
        end

        it '病歴一覧リンクの遷移先確認' do
          medical_history_link = find_all('a')[13]
          medical_history_link.click
          expect(page).to have_current_path user_medical_histories_path(user)
        end

         it '健康管理一覧リンクの遷移先確認' do
          health_care_link = find_all('a')[14]
          health_care_link.click
          expect(page).to have_current_path user_health_cares_path(user)
        end

        it 'かかりつけ医一覧リンクの遷移先確認' do
          family_link = find_all('a')[15]
          family_link.click
          expect(page).to have_current_path families_user_path(user)
        end

        it '日常記録の新規投稿リンクの遷移先確認' do
          daily_record_new_link = find_all('a')[16]
          daily_record_new_link.click
          expect(page).to have_current_path new_daily_record_path
        end

        it '日常記録の詳細リンクの遷移先確認' do
          daily_record_show_link = find_all('a')[17]
          daily_record_show_link.click
          expect(page).to have_current_path daily_record_path(daily_record)
        end
      end
    end

    describe '編集画面' do
      before do
        sign_in_as(user)
        visit edit_user_path(user)
      end

      context '表示の確認' do
        it '編集前の内容が表示されている' do
          expect(page).to have_field 'user[last_name]', with: '広島'
          expect(page).to have_field 'user[first_name]', with: '太郎'
          expect(page).to have_field 'user[last_name_kana]', with: 'ヒロシマ'
          expect(page).to have_field 'user[first_name_kana]', with: 'タロウ'
          expect(page).to have_field 'user[address]', with: '広島県'
          expect(page).to have_field 'user[email]', with: 'h@h'
          expect(page).to have_field 'user[telphone_number]', with: 000000000000
          expect(page).to have_field 'user[postal_code]', with: 00000000
        end

        it '更新ボタンが表示される' do
          expect(page).to have_button '編集する'
        end
      end

      context '動作の確認' do
        it '更新に成功しサクセスメッセージが表示されるか' do
          fill_in 'user[last_name]', with: '広島あ'
          fill_in 'user[first_name]', with: '太郎あ'
          fill_in 'user[last_name_kana]', with: 'ヒロシマあ'
          fill_in 'user[first_name_kana]', with: 'タロウあ'
          fill_in 'user[address]', with: '広島県あ'
          fill_in 'user[email]', with: 'h@hあ'
          fill_in 'user[telphone_number]', with: 000000000000
          fill_in 'user[postal_code]', with: 00000000
          click_button '編集する'
          expect(page).to have_content '更新しました'
        end

        it '更新に失敗しエラーメッセージが表示されるか' do
          fill_in 'user[last_name]', with: ''
          fill_in 'user[first_name]', with: ''
          fill_in 'user[last_name_kana]', with: ''
          fill_in 'user[first_name_kana]', with: ''
          fill_in 'user[address]', with: ''
          fill_in 'user[email]', with: ''
          fill_in 'user[telphone_number]', with: ''
          fill_in 'user[postal_code]', with: ''
          click_button '編集する'
          expect(page).to have_content '姓を入力してください'
          expect(page).to have_content '名を入力してください'
          expect(page).to have_content 'セイを入力してください'
          expect(page).to have_content 'メイを入力してください'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content '郵便番号は数値で入力してください'
          expect(page).to have_content '住所を入力してください'
          expect(page).to have_content '電話番号は数値で入力してください'
        end

        it '更新後のリダイレクト先は正しいか' do
          fill_in 'user[last_name]', with: '広島あ'
          fill_in 'user[first_name]', with: '太郎あ'
          fill_in 'user[last_name_kana]', with: 'ヒロシマあ'
          fill_in 'user[first_name_kana]', with: 'タロウあ'
          fill_in 'user[address]', with: '広島県あ'
          fill_in 'user[email]', with: 'h@hあ'
          fill_in 'user[telphone_number]', with: 000000000000
          fill_in 'user[postal_code]', with: 00000000
          click_button '編集する'
          expect(page).to have_current_path user_path(user)
        end
      end
    end

    describe '退会画面' do
      before do
        sign_in_as(user)
        visit user_delete_confirm_path(user)
      end

      context '表示の確認' do
        it '題名・氏名が表示されている' do
          expect(page).to have_content '退会手続き'
          expect(page).to have_content user.last_name
          expect(page).to have_content user.first_name
        end
      end

      context '動作の確認' do
        it '退会の確認' do
          expect{ user.destroy }.to change{ User.count }.by(-1)
        end

        it '退会に成功しメッセージが表示される' do
          destroy_link = find_all('a')[11]
          destroy_link.click
          expect(page).to have_content '退会しました'
          expect(page).to have_current_path root_path
        end
      end
    end

    describe '新規登録画面' do
      before do
        visit new_user_registration_path
      end

      context '表示の確認' do
        it "投稿フォームが表示される" do
          expect(page).to have_content '新規登録（個人利用者さま）'
          expect(page).to have_field 'user[last_name]'
          expect(page).to have_field 'user[first_name]'
          expect(page).to have_field 'user[last_name_kana]'
          expect(page).to have_field 'user[first_name_kana]'
          expect(page).to have_field 'user[address]'
          expect(page).to have_field 'user[email]'
          expect(page).to have_field 'user[telphone_number]'
          expect(page).to have_field 'user[postal_code]'
          expect(page).to have_field 'user[password]'
          expect(page).to have_field 'user[password_confirmation]'
        end

        it '新規登録ボタンが表示される' do
          expect(page).to have_button '新規登録'
        end
      end

      context '新規登録処理に関するテスト' do
        it '投稿に成功しサクセスメッセージが表示されるか' do
          fill_in 'user[last_name]', with: '横浜'
          fill_in 'user[first_name]', with: '太郎'
          fill_in 'user[last_name_kana]', with: 'ヒロシマ'
          fill_in 'user[first_name_kana]', with: 'タロウ'
          fill_in 'user[address]', with: '広島県'
          fill_in 'user[email]', with: 'y@y'
          fill_in 'user[telphone_number]', with: 000000000000
          fill_in 'user[postal_code]', with: 00000000
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '新規登録'
          expect(page).to have_content 'アカウント登録が完了しました'
        end

        it '新規登録に失敗する' do
          click_button '新規登録'
          expect(page).to have_content '姓を入力してください'
          expect(page).to have_content '名を入力してください'
          expect(page).to have_content 'セイを入力してください'
          expect(page).to have_content 'メイを入力してください'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(page).to have_content '郵便番号は数値で入力してください'
          expect(page).to have_content '住所を入力してください'
          expect(page).to have_content '電話番号は数値で入力してください'
          expect(page).to have_content 'パスワードを入力してください'
          expect(current_path).to eq('/users')
        end

        it '投稿後のリダイレクト先は正しいか' do
          fill_in 'user[last_name]', with: '横浜'
          fill_in 'user[first_name]', with: '太郎'
          fill_in 'user[last_name_kana]', with: 'ヒロシマ'
          fill_in 'user[first_name_kana]', with: 'タロウ'
          fill_in 'user[address]', with: '広島県'
          fill_in 'user[email]', with: 'y@y'
          fill_in 'user[telphone_number]', with: 000000000000
          fill_in 'user[postal_code]', with: 00000000
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '新規登録'
          expect(page).to have_current_path user_path(3)
        end
      end
    end

    describe 'ログイン画面' do
      before do
        visit new_user_session_path
      end

      context '表示の確認' do
        it "投稿フォームが表示される" do
          expect(page).to have_content 'ログイン（個人利用者さま）'
          expect(page).to have_field 'user[email]'
          expect(page).to have_field 'user[password]'
        end

        it '新規登録ボタンが表示される' do
          expect(page).to have_button 'ログイン'
        end
      end

      context 'ログイン処理に関するテスト' do
        it 'ログインに成功しサクセスメッセージが表示されるか' do
          fill_in 'user[email]', with: 'h@h'
          fill_in 'user[password]', with: 'password'
          click_button 'ログイン'
          expect(page).to have_content 'ログインしました'
        end

        it 'ログインに失敗する' do
          click_button 'ログイン'
          expect(page).to have_content 'メールアドレスまたはパスワードが違います'
          expect(current_path).to eq('/users/sign_in')
        end

        it 'ログイン後のリダイレクト先は正しいか' do
          fill_in 'user[email]', with: 'h@h'
          fill_in 'user[password]', with: 'password'
          click_button 'ログイン'
          expect(page).to have_current_path user_path(user)
        end
      end
    end

    describe 'かかりつけ医一覧画面' do
      before do
        sign_in_as(user)
        family_registration(user, hospital)
        visit families_user_path(user)
      end

      context '表示の確認' do
        it '題名・かかりつけ医の医療機関名・電話番号・郵便番号・住所が表示されているか' do
          expect(page).to have_content 'かかりつけ医一覧'
          expect(page).to have_content hospital.name
          expect(page).to have_content hospital.telphone_number
          expect(page).to have_content hospital.postal_code
          expect(page).to have_content hospital.address
        end

        it '医療機関一覧へのリンクが表示されているか' do
          expect(page).to have_link('医療機関一覧へ', href: '/hospitals')
        end

        it '医療機関詳細へのリンクが表示されているか' do
          expect(page).to have_link(hospital.name, href: '/hospitals/' + hospital.id.to_s)
        end
      end

      context '動作の確認' do
        it '医療機関一覧リンクの遷移先確認' do
          hospitals_link = find_all('a')[12]
          hospitals_link.click
          expect(page).to have_current_path hospitals_path
        end

        it '医療機関詳細のリンク遷移先確認' do
          family_link = find_all('a')[11]
          family_link.click
          expect(page).to have_current_path hospital_path(hospital)
        end
      end
    end
  end

  describe '個人利用者ログイン（本人以外）' do
    before do
      sign_in_as(user2)
    end

    describe '他者マイページ（詳細）画面' do
      before do
        visit user_path(user)
      end

      context '表示の確認' do
        it '氏名が表示されているか' do
          expect(page).to have_content user.first_name
          expect(page).to have_content user.last_name
        end

        it '基本情報編集・退会ページへのリンクが表示されていないか' do
          expect(page).not_to have_link('基本情報編集する', href: '/users/' + user.id.to_s + '/edit')
          expect(page).not_to have_link('退会手続きへ', href: '/users/' + user.id.to_s + '/delete_confirm')
        end

        it '病歴・健康管理・かかりつけ医の一覧へのリンクが表示されていないか' do
          expect(page).not_to have_link('一覧へ', href: '/users/' + user.id.to_s + '/medical_histories')
          expect(page).not_to have_link('一覧へ', href: '/users/' + user.id.to_s + '/health_cares')
          expect(page).not_to have_link('一覧へ', href: '/users/' + user.id.to_s + '/families')
        end

        it '日常記録の題名・ジャンルが表示されているか' do
          expect(page).to have_content daily_record.theme
          expect(page).to have_content daily_record.genre
        end

        it '日常記録の新規投稿へのリンクが表示されていないか' do
          expect(page).not_to have_link('新しく投稿する！', href: '/daily_records/new')
        end

        it '日常記録の詳細へのリンクが表示されているか' do
          expect(page).to have_link(daily_record.theme, href: '/daily_records/' + daily_record.id.to_s)
        end
      end

      context '動作の確認' do
        it '日常記録の詳細リンクの遷移先確認' do
          daily_record_show_link = find_all('a')[11]
          daily_record_show_link.click
          expect(page).to have_current_path daily_record_path(daily_record)
        end
      end
    end

    describe '編集画面' do
      before do
        visit edit_user_path(user)
      end

      context '表示の確認' do
        it 'ログイン画面へ遷移させられている' do
          expect(page).to have_current_path user_path(user2)
        end
      end
    end

    describe '退会画面' do
      before do
        visit user_delete_confirm_path(user)
      end

      it 'ログイン画面へ遷移させられている' do
        expect(page).to have_current_path user_path(user2)
      end
    end

    describe 'かかりつけ医一覧画面' do
      before do
        visit families_user_path(user)
      end

      context '表示の確認' do
        it '自分のマイページへ遷移させられている' do
          expect(page).to have_current_path user_path(user2)
        end
      end
    end
  end

  describe '医療関係者ログイン（かかりつけあり）' do
    before do
      family_registration(user, hospital)
      sign_in_as_hospital(hospital)
    end

    describe '個人利用者マイページ（詳細）画面' do
      before do
        visit user_path(user)
      end

      context '表示の確認' do
        it '氏名が表示されているか' do
          expect(page).to have_content user.first_name
          expect(page).to have_content user.last_name
        end

        it '基本情報編集・退会ページへのリンクが表示されていないか' do
          expect(page).not_to have_link('基本情報編集する', href: '/users/' + user.id.to_s + '/edit')
          expect(page).not_to have_link('退会手続きへ', href: '/users/' + user.id.to_s + '/delete_confirm')
        end

        it '病歴・健康管理・かかりつけ医の一覧へのリンクが表示されているか' do
          expect(page).to have_link('一覧へ', href: '/users/' + user.id.to_s + '/medical_histories')
          expect(page).to have_link('一覧へ', href: '/users/' + user.id.to_s + '/health_cares')
          expect(page).to have_link('一覧へ', href: '/users/' + user.id.to_s + '/families')
        end

        it '日常記録の題名・ジャンルが表示されているか' do
          expect(page).to have_content daily_record.theme
          expect(page).to have_content daily_record.genre
        end

        it '日常記録の新規投稿へのリンクが表示されていないか' do
          expect(page).not_to have_link('新しく投稿する！', href: '/daily_records/new')
        end

        it '日常記録詳細へのリンクが表示されているか' do
          expect(page).to have_link(daily_record.theme, href: '/daily_records/' + daily_record.id.to_s)
        end
      end

      context '動作の確認' do
        it '病歴一覧リンクの遷移先確認' do
          medical_history_link = find_all('a')[7]
          medical_history_link.click
          expect(page).to have_current_path user_medical_histories_path(user)
        end

         it '健康管理一覧リンクの遷移先確認' do
          health_care_link = find_all('a')[8]
          health_care_link.click
          expect(page).to have_current_path user_health_cares_path(user)
        end

        it 'かかりつけ医一覧リンクの遷移先確認' do
          family_link = find_all('a')[9]
          family_link.click
          expect(page).to have_current_path families_user_path(user)
        end

        it '日常記録の詳細リンクの遷移先確認' do
          daily_record_show_link = find_all('a')[10]
          daily_record_show_link.click
          expect(page).to have_current_path daily_record_path(daily_record)
        end
      end
    end

    describe 'かかりつけ医一覧画面' do
      before do
        visit families_user_path(user)
      end

      context '表示の確認' do
        it '題名・かかりつけ医の医療機関名・電話番号・郵便番号・住所が表示されているか' do
          expect(page).to have_content 'かかりつけ医一覧'
          expect(page).to have_content hospital.name
          expect(page).to have_content hospital.telphone_number
          expect(page).to have_content hospital.postal_code
          expect(page).to have_content hospital.address
        end

        it '医療機関一覧へのリンクが表示されているか' do
          expect(page).to have_link('医療機関一覧へ', href: '/hospitals')
        end

        it '医療機関詳細へのリンクが表示されているか' do
          expect(page).to have_link(hospital.name, href: '/hospitals/' + hospital.id.to_s)
        end

        it '患者マイページへのリンクが表示されているか' do
          expect(page).to have_link('患者マイページへ戻る', href: '/users/' + user.id.to_s)
        end
      end

      context '動作の確認' do
        it '医療機関一覧リンクの遷移先確認' do
          hospitals_link = find_all('a')[8]
          hospitals_link.click
          expect(page).to have_current_path hospitals_path
        end

        it '医療機関詳細リンク遷移先確認' do
          family_link = find_all('a')[7]
          family_link.click
          expect(page).to have_current_path hospital_path(hospital)
        end

        it '患者マイページリンク遷移先確認' do
          user_link = find_all('a')[9]
          user_link.click
          expect(page).to have_current_path user_path(user)
        end
      end
    end

    describe '編集画面' do
      before do
        visit edit_user_path(user)
      end

      context '表示の確認' do
        it 'ログイン画面へ遷移させられている' do
          expect(page).to have_current_path new_user_session_path
        end
      end
    end

    describe '退会画面' do
      before do
        visit user_delete_confirm_path(user)
      end

      it 'ログイン画面へ遷移させられている' do
        expect(page).to have_current_path new_user_session_path
      end
    end
  end

  describe '医療関係者ログイン（かかりつけなし）' do
    before do
      sign_in_as_hospital(hospital2)
    end

    describe 'マイページ（詳細）画面' do
      before do
        visit user_path(user)
      end

      context '表示の確認' do
        it 'メッセージが表示されているか' do
          expect(page).to have_content 'かかりつけ医の登録がされていない患者です'
        end
      end
    end

    describe '編集画面' do
      before do
        visit edit_user_path(user)
      end

      context '表示の確認' do
        it 'ログイン画面へ遷移させられている' do
          expect(page).to have_current_path new_user_session_path
        end
      end
    end

    describe '退会画面' do
      before do
        visit user_delete_confirm_path(user)
      end

      it 'ログイン画面へ遷移させられている' do
        expect(page).to have_current_path new_user_session_path
      end
    end

    describe 'かかりつけ医一覧画面' do
      before do
        visit families_user_path(user)
      end

      context '表示の確認' do
        it '自分のマイページへ遷移させられている' do
          expect(page).to have_current_path hospital_path(hospital2)
        end
      end
    end
  end
end