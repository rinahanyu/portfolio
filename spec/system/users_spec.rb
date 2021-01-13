require 'rails_helper'

describe "個人利用者関連テスト" do
  let!(:user) {FactoryBot.create(:user)}
  let!(:daily_record) {FactoryBot.create(:daily_record, user: user)}

  before do
    sign_in_as(user)
  end

  describe '詳細画面' do
    before do
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

  # ---------------------

  # describe '編集画面' do
  #   before do
  #     visit edit_daily_record_path(daily_record)
  #   end

  #   context '表示の確認' do
  #     it '編集前の内容が表示されている' do
  #       expect(page).to have_field 'daily_record[theme]', with: '題名'
  #       expect(page).to have_field 'daily_record[introduction]', with: '内容'
  #       select(value = '食事', from: 'daily_record_genre')
  #     end

  #     it '更新ボタンが表示される' do
  #       expect(page).to have_button '変更を保存'
  #     end
  #   end

  #   context '動作の確認' do
  #     it '更新に成功しサクセスメッセージが表示されるか' do
  #       fill_in 'daily_record[theme]', with: '題名２'
  #       fill_in 'daily_record[introduction]', with: '内容２'
  #       select '運動', from: 'daily_record_genre'
  #       click_button '変更を保存'
  #       expect(page).to have_content '更新しました'
  #     end

  #     it '更新に失敗しエラーメッセージが表示されるか' do
  #       fill_in 'daily_record[theme]', with: ''
  #       fill_in 'daily_record[introduction]', with: ''
  #       select(value = '食事', from: 'daily_record[genre]')
  #       click_button '変更を保存'
  #       expect(page).to have_content '入力してください'
  #     end

  #     it '更新後のリダイレクト先は正しいか' do
  #       fill_in 'daily_record[theme]', with: '題名２'
  #       fill_in 'daily_record[introduction]', with: '内容２'
  #       select '運動', from: 'daily_record_genre'
  #       click_button '変更を保存'
  #       expect(page).to have_current_path daily_record_path(daily_record)
  #     end
  #   end
  # end

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