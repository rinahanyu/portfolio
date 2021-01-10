require 'rails_helper'

describe "健康管理関連テスト" do
  let!(:user) {FactoryBot.create(:user)}
  let!(:health_care) {FactoryBot.create(:health_care, user: user)}

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
        fill_in 'health_care[body_weight]', with: 00
        fill_in 'health_care[max_blood_pressure]', with: 00
        fill_in 'health_care[min_blood_pressure]', with: 00
        fill_in 'health_care[blood_sugar]', with: 00
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
        fill_in 'health_care[body_weight]', with: 00
        fill_in 'health_care[max_blood_pressure]', with: 00
        fill_in 'health_care[min_blood_pressure]', with: 00
        fill_in 'health_care[blood_sugar]', with: 00
        select '2021', from: 'health_care_date_1i'
        select '1', from: 'health_care_date_2i'
        select '5', from: 'health_care_date_3i'
        click_button '新規登録'
        expect(page).to have_current_path user_health_cares_path(user)
      end
    end
  end

  # describe '詳細画面' do
  #   before do
  #     visit daily_record_path(daily_record)
  #   end

  #   context '表示の確認' do
  #     it '日常記録の題名・内容・ジャンル名が表示されているか' do
  #       expect(page).to have_content daily_record.theme
  #       expect(page).to have_content daily_record.introduction
  #       expect(page).to have_content daily_record.genre
  #     end

  #     it '編集のリンクが表示されているか' do
  #       expect(page).to have_link('編集する', href: '/daily_records/' + daily_record.id.to_s + '/edit')
  #     end
  #   end

  #   context '動作の確認' do
  #     it '編集リンクの遷移先確認' do
  #       edit_link = find_all('a')[12]
  #       edit_link.click
  #       expect(page).to have_current_path edit_daily_record_path(daily_record)
  #     end

  #     it '削除の確認' do
  #       expect{ daily_record.destroy }.to change{ DailyRecord.count }.by(-1)
  #     end

  #     it '削除に成功しメッセージが表示される' do
  #       destroy_link = find_all('a')[13]
  #       destroy_link.click
  #       expect(page).to have_content '削除しました'
  #     end
  #   end
  # end

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

  # describe '一覧画面' do
  #   before do
  #     (1..4).each do |i|
  #       FactoryBot.create(:daily_record, theme: '題名テスト'+ i.to_s, introduction: '内容テスト'+ i.to_s, user: user)
  #     end
  #     visit daily_records_path
  #   end

  #   context '表示の確認' do
  #     it "daily_recordの題名・ジャンル・投稿者の表示がされているか" do
  #       DailyRecord.all.each_with_index do |daily_record|
  #         expect(page).to have_content daily_record.theme
  #         expect(page).to have_content daily_record.genre
  #         expect(page).to have_content daily_record.user.last_name
  #       end
  #     end
  #     it "詳細・投稿者マイページへのリンクが表示されているか" do
  #       DailyRecord.all.each_with_index do |daily_record|
  #         expect(page).to have_link(daily_record.theme, href: '/daily_records/' + daily_record.id.to_s)
  #         expect(page).to have_link(daily_record.user.last_name, href: '/users/' + daily_record.user_id.to_s)
  #       end
  #     end
  #   end

  #   context '動作の確認' do
  #     it '詳細リンクの遷移先確認' do
  #       DailyRecord.all.each_with_index do |daily_record, i|
  #         j = i * 2
  #         show_link = find_all('a')[22 - j]
	 #       expect(show_link[:href]).to eq daily_record_path(daily_record)
	 #     end
  #     end

  #     it '投稿者マイページリンクの遷移先確認' do
  #       DailyRecord.all.each_with_index do |daily_record, i|
  #         j = i * 2
  #         mypage_link = find_all('a')[23 - j]
	 #       expect(mypage_link[:href]).to eq user_path(daily_record.user)
	 #     end
  #     end
  #   end
  # end
end