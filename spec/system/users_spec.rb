require 'rails_helper'

describe "個人利用者関連テスト" do
  let(:user) {FactoryBot.create(:user)}
  let!(:daily_record) {FactoryBot.create(:daily_record, user: user)}

  describe '詳細画面' do
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
        expect(page).to have_field 'user[telphone_number]', with: 0o0000000000
        expect(page).to have_field 'user[postal_code]', with: 0o000000
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
        fill_in 'user[telphone_number]', with: 0o0000000000
        fill_in 'user[postal_code]', with: 0o000000
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
        fill_in 'user[telphone_number]', with: 0o0000000000
        fill_in 'user[postal_code]', with: 0o000000
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
        fill_in 'user[last_name]', with: '広島'
        fill_in 'user[first_name]', with: '太郎'
        fill_in 'user[last_name_kana]', with: 'ヒロシマ'
        fill_in 'user[first_name_kana]', with: 'タロウ'
        fill_in 'user[address]', with: '広島県'
        fill_in 'user[email]', with: 'h@h'
        fill_in 'user[telphone_number]', with: 0o0000000000
        fill_in 'user[postal_code]', with: 0o000000
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button '新規登録'
        expect(page).to have_content 'ログインしました'
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
        fill_in 'user[last_name]', with: '広島あ'
        fill_in 'user[first_name]', with: '太郎あ'
        fill_in 'user[last_name_kana]', with: 'ヒロシマあ'
        fill_in 'user[first_name_kana]', with: 'タロウあ'
        fill_in 'user[address]', with: '広島県あ'
        fill_in 'user[email]', with: 'h@hあ'
        fill_in 'user[telphone_number]', with: 0o0000000000
        fill_in 'user[postal_code]', with: 0o000000
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button '新規登録'
        expect(page).to have_current_path user_path(user)
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
end