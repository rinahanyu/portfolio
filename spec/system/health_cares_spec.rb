require 'rails_helper'

describe "健康管理関連テスト" do
  let!(:user) {FactoryBot.create(:user)}
  let!(:hospital) {FactoryBot.create(:hospital)}
  let!(:health_care) {FactoryBot.create(:health_care, user: user)}

  describe '個人利用者ログイン' do
    before do
      sign_in_as(user)
    end

    describe '新規登録画面' do
      before do
        visit new_user_health_care_path(user)
      end

      context '表示の確認' do
        it "投稿フォームが表示される" do
          expect(page).to have_content '健康管理の新規登録'
          expect(page).to have_field 'health_care[body_weight]'
          expect(page).to have_field 'health_care[max_blood_pressure]'
          expect(page).to have_field 'health_care[min_blood_pressure]'
          expect(page).to have_field 'health_care[blood_sugar]'
          expect(page).to have_select 'health_care[date(1i)]'
          expect(page).to have_select 'health_care[date(2i)]'
          expect(page).to have_select 'health_care[date(3i)]'
        end

        it '新規登録ボタンが表示される' do
          expect(page).to have_button '新規登録'
        end
      end

      context '投稿処理に関するテスト' do
        it '投稿に成功しサクセスメッセージが表示されるか' do
          fill_in 'health_care[body_weight]', with: 0
          fill_in 'health_care[max_blood_pressure]', with: 0
          fill_in 'health_care[min_blood_pressure]', with: 0
          fill_in 'health_care[blood_sugar]', with: 0
          select '2021', from: 'health_care_date_1i'
          select '1', from: 'health_care_date_2i'
          select '5', from: 'health_care_date_3i'
          click_button '新規登録'
          expect(page).to have_content '投稿しました'
        end

        it '投稿に失敗する' do
          click_button '新規登録'
          expect(page).to have_content '体重・最高血圧・最低血圧・血糖値のいずれかを入力してください'
          expect(current_path).to eq('/users/' + user.id.to_s + '/health_cares')
        end

        it '投稿後のリダイレクト先は正しいか' do
          fill_in 'health_care[body_weight]', with: 0
          fill_in 'health_care[max_blood_pressure]', with: 0
          fill_in 'health_care[min_blood_pressure]', with: 0
          fill_in 'health_care[blood_sugar]', with: 0
          select '2021', from: 'health_care_date_1i'
          select '1', from: 'health_care_date_2i'
          select '5', from: 'health_care_date_3i'
          click_button '新規登録'
          expect(page).to have_current_path user_health_cares_path(user)
        end
      end
    end

    describe '一覧画面' do
      before do
        (1..4).each do |i|
          FactoryBot.create(:health_care, body_weight: 0 + i, max_blood_pressure: 0 + i,
          min_blood_pressure: 0 + i, blood_sugar: 0 + i, date: '2021-01-05', user: user)
        end
        visit user_health_cares_path(user)
      end

      context '表示の確認' do
        it "健康管理の体重・最高血圧・最低血圧・血糖値・日付の表示がされているか" do
          HealthCare.all.each_with_index do |health_care|
            expect(page).to have_content health_care.body_weight
            expect(page).to have_content health_care.max_blood_pressure
            expect(page).to have_content health_care.min_blood_pressure
            expect(page).to have_content health_care.blood_sugar
            expect(page).to have_content health_care.date.strftime("%Y年%m月%d日")
          end
        end

        it "編集へのリンクが表示されているか" do
          HealthCare.all.each_with_index do |health_care|
            expect(page).to have_link('編集', href: '/users/' + user.id.to_s + '/health_cares/' + health_care.id.to_s + '/edit')
          end
        end

        it "新規投稿へのリンクが表示されているか" do
          expect(page).to have_link('新しい数値を記録する', href: '/users/' + user.id.to_s + '/health_cares/new')
        end
      end

      context '動作の確認' do
        it '新規投稿リンクの遷移先確認' do
          new_link = find_all('a')[21]
          new_link.click
          expect(page).to have_content '健康管理の新規登録'
        end

        it '編集リンクの遷移先確認' do
          HealthCare.all.each_with_index do |health_care, i|
            j = i * 2
            edit_link = find_all('a')[11 + j]
  	        expect(edit_link[:href]).to eq edit_user_health_care_path(user, health_care)
  	      end
        end

        it '削除の確認' do
          HealthCare.all.each_with_index do |health_care|
            expect{ health_care.destroy }.to change{ HealthCare.count }.by(-1)
          end
        end

        it '削除に成功しメッセージが表示される' do
          HealthCare.all.each_with_index do |health_care, i|
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
        visit edit_user_health_care_path(health_care, user)
      end

      context '表示の確認' do
        it '編集前の内容が表示されている' do
          expect(page).to have_field 'health_care[body_weight]', with: 00
          expect(page).to have_field 'health_care[max_blood_pressure]', with: 00
          expect(page).to have_field 'health_care[min_blood_pressure]', with: 00
          expect(page).to have_field 'health_care[blood_sugar]', with: 00
          select(value = '2021', from: 'health_care_date_1i')
          select(value = '1', from: 'health_care_date_2i')
          select(value = '5', from: 'health_care_date_3i')
        end

        it '更新ボタンが表示される' do
          expect(page).to have_button '変更を保存'
        end
      end

      context '動作の確認' do
        it '更新に成功しサクセスメッセージが表示されるか' do
          fill_in 'health_care[body_weight]', with: 11
          fill_in 'health_care[max_blood_pressure]', with: 11
          fill_in 'health_care[min_blood_pressure]', with: 11
          fill_in 'health_care[blood_sugar]', with: 11
          select '2021', from: 'health_care_date_1i'
          select '1', from: 'health_care_date_2i'
          select '5', from: 'health_care_date_3i'
          click_button '変更を保存'
          expect(page).to have_content '更新しました'
        end

        it '更新に失敗しエラーメッセージが表示されるか' do
          fill_in 'health_care[body_weight]', with: ''
          fill_in 'health_care[max_blood_pressure]', with: ''
          fill_in 'health_care[min_blood_pressure]', with: ''
          fill_in 'health_care[blood_sugar]', with: ''
          select '', from: 'health_care_date_1i'
          select '', from: 'health_care_date_2i'
          select '', from: 'health_care_date_3i'
          click_button '変更を保存'
          expect(page).to have_content '体重・最高血圧・最低血圧・血糖値のいずれかを入力してください'
          expect(page).to have_content '日付を入力してください'
        end

        it '更新後のリダイレクト先は正しいか' do
          fill_in 'health_care[body_weight]', with: 11
          fill_in 'health_care[max_blood_pressure]', with: 11
          fill_in 'health_care[min_blood_pressure]', with: 11
          fill_in 'health_care[blood_sugar]', with: 11
          select '2021', from: 'health_care_date_1i'
          select '1', from: 'health_care_date_2i'
          select '5', from: 'health_care_date_3i'
          click_button '変更を保存'
          expect(page).to have_current_path user_health_cares_path(user)
        end
      end
    end
  end

  describe '医療関係者ログイン' do
    before do
      family_registration(user, hospital)
      sign_in_as_hospital(hospital)
    end

    describe '一覧画面' do
      before do
        (1..4).each do |i|
          FactoryBot.create(:health_care, body_weight: 0 + i, max_blood_pressure: 0 + i,
          min_blood_pressure: 0 + i, blood_sugar: 0 + i, date: '2021-01-05', user: user)
        end
        visit user_health_cares_path(user)
      end

      context '表示の確認' do
        it "健康管理の体重・最高血圧・最低血圧・血糖値・日付の表示がされているか" do
          HealthCare.all.each_with_index do |health_care|
            expect(page).to have_content health_care.body_weight
            expect(page).to have_content health_care.max_blood_pressure
            expect(page).to have_content health_care.min_blood_pressure
            expect(page).to have_content health_care.blood_sugar
            expect(page).to have_content health_care.date.strftime("%Y年%m月%d日")
          end
        end

        it "編集へのリンクが表示されていないか" do
          HealthCare.all.each_with_index do |health_care|
            expect(page).not_to have_link('編集', href: '/users/' + user.id.to_s + '/health_cares/' + health_care.id.to_s + '/edit')
          end
        end

        it "新規投稿へのリンクが表示されていないか" do
          expect(page).not_to have_link('新しい数値を記録する', href: '/users/' + user.id.to_s + '/health_cares/new')
        end
      end
    end
  end
end