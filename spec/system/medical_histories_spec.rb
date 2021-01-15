require 'rails_helper'

describe "病歴関連テスト" do
  let!(:user) {FactoryBot.create(:user)}
  let!(:user2) {FactoryBot.create(:user, email: 'h@h2')}
  let!(:hospital) {FactoryBot.create(:hospital)}
  let!(:hospital2) {FactoryBot.create(:hospital, email: 's@s2')}
  let!(:medical_history) {FactoryBot.create(:medical_history, user: user)}

  describe '個人利用者ログイン（本人）' do
    before do
      sign_in_as(user)
    end

    describe '新規登録画面' do
      before do
        visit new_user_medical_history_path(user)
      end

      context '表示の確認' do
        it "投稿フォームが表示される" do
          expect(page).to have_content '病歴の新規登録'
          expect(page).to have_field 'medical_history[disease]'
          expect(page).to have_select 'medical_history[started_on(1i)]'
          expect(page).to have_select 'medical_history[started_on(2i)]'
          expect(page).to have_select 'medical_history[started_on(3i)]'
          expect(page).to have_select 'medical_history[finished_on(1i)]'
          expect(page).to have_select 'medical_history[finished_on(2i)]'
          expect(page).to have_select 'medical_history[finished_on(3i)]'
          expect(page).to have_field 'medical_history[treatment]'
          expect(page).to have_field 'medical_history[hospital]'
        end

        it '新規登録ボタンが表示される' do
          expect(page).to have_button '新規登録'
        end
      end

      context '投稿処理に関するテスト' do
        it '投稿に成功しサクセスメッセージが表示されるか' do
          fill_in 'medical_history[disease]', with: '傷病名'
          select '2021', from: 'medical_history[started_on(1i)]'
          select '1', from: 'medical_history[started_on(2i)]'
          select '1', from: 'medical_history[started_on(3i)]'
          select '2021', from: 'medical_history[finished_on(1i)]'
          select '1', from: 'medical_history[finished_on(2i)]'
          select '1', from: 'medical_history[finished_on(3i)]'
          fill_in 'medical_history[treatment]', with: '治療内容'
          fill_in 'medical_history[hospital]', with: '治療先'
          click_button '新規登録'
          expect(page).to have_content '投稿しました'
        end

        it '投稿に失敗する' do
          click_button '新規登録'
          expect(page).to have_content '傷病名を入力してください'
          expect(page).to have_content '治療開始日を入力してください'
          expect(page).to have_content '治療内容を入力してください'
          expect(page).to have_content '治療先を入力してください'
          expect(current_path).to eq('/users/' + user.id.to_s + '/medical_histories')
        end

        it '投稿後のリダイレクト先は正しいか' do
          fill_in 'medical_history[disease]', with: '傷病名'
          select '2021', from: 'medical_history[started_on(1i)]'
          select '1', from: 'medical_history[started_on(2i)]'
          select '1', from: 'medical_history[started_on(3i)]'
          select '2021', from: 'medical_history[finished_on(1i)]'
          select '1', from: 'medical_history[finished_on(2i)]'
          select '1', from: 'medical_history[finished_on(3i)]'
          fill_in 'medical_history[treatment]', with: '治療内容'
          fill_in 'medical_history[hospital]', with: '治療先'
          click_button '新規登録'
          expect(page).to have_current_path user_medical_histories_path(user)
        end
      end
    end

    describe '一覧画面' do
      before do
        (1..4).each do |i|
          FactoryBot.create(:medical_history, disease: '傷病名テスト' + i.to_s, started_on: '2021-01-01', finished_on: '2021-01-01',
          treatment: '治療内容テスト' + i.to_s, hospital: '治療先テスト' + i.to_s, user: user)
        end
        visit user_medical_histories_path(user)
      end

      context '表示の確認' do
        it "傷病名・治療開始日・治療終了日・治療内容・治療先の表示がされているか" do
          MedicalHistory.all.each_with_index do |medical_history|
            expect(page).to have_content medical_history.disease
            expect(page).to have_content medical_history.started_on.strftime("%Y年%m月%d日")
            expect(page).to have_content medical_history.finished_on.strftime("%Y年%m月%d日")
            expect(page).to have_content medical_history.treatment
            expect(page).to have_content medical_history.hospital
          end
        end

        it "編集へのリンクが表示されているか" do
          MedicalHistory.all.each_with_index do |medical_history|
            expect(page).to have_link('編集', href: '/users/' + user.id.to_s + '/medical_histories/' + medical_history.id.to_s + '/edit')
          end
        end

        it "新規投稿へのリンクが表示されているか" do
          expect(page).to have_link('新しい歴史をつくる', href: '/users/' + user.id.to_s + '/medical_histories/new')
        end
      end

      context '動作の確認' do
        it '新規投稿リンクの遷移先確認' do
          new_link = find_all('a')[21]
          new_link.click
          expect(page).to have_content '病歴の新規登録'
        end

        it '編集リンクの遷移先確認' do
          MedicalHistory.all.each_with_index do |medical_history, i|
            j = i * 2
            edit_link = find_all('a')[11 + j]
            expect(edit_link[:href]).to eq edit_user_medical_history_path(user, medical_history)
          end
        end

        it '削除の確認' do
          MedicalHistory.all.each_with_index do |medical_history|
            expect{ medical_history.destroy }.to change{ MedicalHistory.count }.by(-1)
          end
        end

        it '削除に成功しメッセージが表示される' do
          MedicalHistory.all.each_with_index do |medical_history, i|
            j = i * 2
            destroy_link = find_all('a')[20 - j]
            # 削除により順番が変わってしまうため、下から順に削除
            destroy_link.click
            expect(page).to have_content '削除しました'
          end
        end
      end
    end

    describe '編集画面' do
      before do
        visit edit_user_medical_history_path(user, medical_history)
      end

      context '表示の確認' do
        it '編集前の内容が表示されている' do
          expect(page).to have_field 'medical_history[disease]', with: '傷病名'
          select(value = '2021', from: 'medical_history_started_on_1i')
          select(value = '1', from: 'medical_history_started_on_2i')
          select(value = '1', from: 'medical_history_started_on_3i')
          select(value = '2021', from: 'medical_history_finished_on_1i')
          select(value = '1', from: 'medical_history_finished_on_2i')
          select(value = '1', from: 'medical_history_finished_on_3i')
          expect(page).to have_field 'medical_history[treatment]', with: '治療内容'
          expect(page).to have_field 'medical_history[hospital]', with: '治療先'
        end

        it '更新ボタンが表示される' do
          expect(page).to have_button '変更を保存'
        end
      end

      context '動作の確認' do
        it '更新に成功しサクセスメッセージが表示されるか' do
          fill_in 'medical_history[disease]', with: '傷病名あ'
          select '2021', from: 'medical_history[started_on(1i)]'
          select '1', from: 'medical_history[started_on(2i)]'
          select '2', from: 'medical_history[started_on(3i)]'
          select '2021', from: 'medical_history[finished_on(1i)]'
          select '1', from: 'medical_history[finished_on(2i)]'
          select '2', from: 'medical_history[finished_on(3i)]'
          fill_in 'medical_history[treatment]', with: '治療内容あ'
          fill_in 'medical_history[hospital]', with: '治療先あ'
          click_button '変更を保存'
          expect(page).to have_content '更新しました'
        end

        it '更新に失敗しエラーメッセージが表示されるか' do
          fill_in 'medical_history[disease]', with: ''
          select '', from: 'medical_history[started_on(1i)]'
          select '', from: 'medical_history[started_on(2i)]'
          select '', from: 'medical_history[started_on(3i)]'
          select '', from: 'medical_history[finished_on(1i)]'
          select '', from: 'medical_history[finished_on(2i)]'
          select '', from: 'medical_history[finished_on(3i)]'
          fill_in 'medical_history[treatment]', with: ''
          fill_in 'medical_history[hospital]', with: ''
          click_button '変更を保存'
          expect(page).to have_content '傷病名を入力してください'
          expect(page).to have_content '治療開始日を入力してください'
          expect(page).to have_content '治療内容を入力してください'
          expect(page).to have_content '治療先を入力してください'
        end

        it '更新後のリダイレクト先は正しいか' do
          fill_in 'medical_history[disease]', with: '傷病名あ'
          select '2021', from: 'medical_history[started_on(1i)]'
          select '1', from: 'medical_history[started_on(2i)]'
          select '2', from: 'medical_history[started_on(3i)]'
          select '2021', from: 'medical_history[finished_on(1i)]'
          select '1', from: 'medical_history[finished_on(2i)]'
          select '2', from: 'medical_history[finished_on(3i)]'
          fill_in 'medical_history[treatment]', with: '治療内容あ'
          fill_in 'medical_history[hospital]', with: '治療先あ'
          click_button '変更を保存'
          expect(page).to have_current_path user_medical_histories_path(user)
        end
      end
    end
  end

  describe '個人利用者ログイン（本人以外）' do
    before do
      sign_in_as(user2)
    end

    describe '一覧画面' do
      before do
        visit user_medical_histories_path(user)
      end

      context '表示の確認' do
        it '自分のマイページへ遷移させられている' do
          expect(page).to have_current_path user_path(user2)
        end
      end
    end

    describe '編集画面' do
      before do
        visit edit_user_medical_history_path(user, medical_history)
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

    describe '一覧画面' do
      before do
        (1..4).each do |i|
          FactoryBot.create(:medical_history, disease: '傷病名テスト' + i.to_s, started_on: '2021-01-01', finished_on: '2021-01-01',
          treatment: '治療内容テスト' + i.to_s, hospital: '治療先テスト' + i.to_s, user: user)
        end
        visit user_medical_histories_path(user)
      end

      context '表示の確認' do
        it "傷病名・治療開始日・治療終了日・治療内容・治療先の表示がされているか" do
          MedicalHistory.all.each_with_index do |medical_history|
            expect(page).to have_content medical_history.disease
            expect(page).to have_content medical_history.started_on.strftime("%Y年%m月%d日")
            expect(page).to have_content medical_history.finished_on.strftime("%Y年%m月%d日")
            expect(page).to have_content medical_history.treatment
            expect(page).to have_content medical_history.hospital
          end
        end

        it "編集へのリンクが表示されていないか" do
          MedicalHistory.all.each_with_index do |medical_history|
            expect(page).not_to have_link('編集', href: '/users/' + user.id.to_s + '/medical_histories/' + medical_history.id.to_s + '/edit')
          end
        end

        it "新規投稿へのリンクが表示されていないか" do
          expect(page).not_to have_link('新しい歴史をつくる', href: '/users/' + user.id.to_s + '/medical_histories/new')
        end
      end
    end

    describe '編集画面' do
      before do
        visit edit_user_medical_history_path(user, medical_history)
      end

      context '表示の確認' do
        it '自分のマイページへ遷移させられている' do
          expect(page).to have_current_path new_user_session_path
        end
      end
    end
  end

  describe '医療関係者ログイン（かかりつけなし）' do
    before do
      sign_in_as_hospital(hospital2)
    end

    describe '一覧画面' do
      before do
        visit user_medical_histories_path(user)
      end

      context '表示の確認' do
        it '自分のマイページへ遷移させられている' do
          expect(page).to have_current_path hospital_path(hospital2)
        end
      end
    end

    describe '編集画面' do
      before do
        visit edit_user_medical_history_path(user, medical_history)
      end

      context '表示の確認' do
        it '自分のマイページへ遷移させられている' do
          expect(page).to have_current_path new_user_session_path
        end
      end
    end
  end
end