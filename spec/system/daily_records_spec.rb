require 'rails_helper'

describe "日常記録関連テスト" do
  let!(:user) {FactoryBot.create(:user)}
  let!(:user2) {FactoryBot.create(:user, email: 'h@h2')}
  let!(:hospital) {FactoryBot.create(:hospital)}
  let!(:daily_record) {FactoryBot.create(:daily_record, user: user)}

  describe '個人利用者ログイン（本人）' do
    before do
      sign_in_as(user)
    end
    
    describe '新規登録画面' do
      before do
        visit new_daily_record_path
      end
      
      context '表示の確認' do
        it "投稿フォームが表示される" do
          expect(page).to have_content '新規登録'
          expect(page).to have_field 'daily_record[daily_image]'
          expect(page).to have_field 'daily_record[theme]'
          expect(page).to have_field 'daily_record[introduction]'
          expect(page).to have_field 'daily_record[genre]'
        end
        
        it '新規登録ボタンが表示される' do
          expect(page).to have_button '新規登録'
        end
      end
      
      context '投稿処理に関するテスト' do
        it '投稿に成功しサクセスメッセージが表示されるか' do
          fill_in 'daily_record[theme]', with: '題名'
          fill_in 'daily_record[introduction]', with: '内容'
          select '食事', from: 'daily_record_genre'
          click_button '新規登録'
          expect(page).to have_content '投稿しました'
        end
        
        it '投稿に失敗する' do
          click_button '新規登録'
          expect(page).to have_content '入力してください'
          expect(current_path).to eq('/daily_records')
        end
        
        it '投稿後のリダイレクト先は正しいか' do
          fill_in 'daily_record[theme]', with: '題名'
          fill_in 'daily_record[introduction]', with: '内容'
          select '食事', from: 'daily_record_genre'
          click_button '新規登録'
          expect(page).to have_current_path user_path(user)
        end
      end
    end
    
    describe '詳細画面' do
      before do
        visit daily_record_path(daily_record)
      end
      
      context '表示の確認' do
        it '日常記録の題名・内容・ジャンル名が表示されているか' do
          expect(page).to have_content daily_record.theme
          expect(page).to have_content daily_record.introduction
          expect(page).to have_content daily_record.genre
        end
        
        it '編集のリンクが表示されているか' do
          expect(page).to have_link('編集する', href: '/daily_records/' + daily_record.id.to_s + '/edit')
        end
      end
      
      context '動作の確認' do
        it '編集リンクの遷移先確認' do
          edit_link = find_all('a')[12]
          edit_link.click
          expect(page).to have_current_path edit_daily_record_path(daily_record)
        end
        
        it '削除の確認' do
          expect{ daily_record.destroy }.to change{ DailyRecord.count }.by(-1)
        end
        
        it '削除に成功しメッセージが表示される' do
          destroy_link = find_all('a')[13]
          destroy_link.click
          expect(page).to have_content '削除しました'
        end
      end
    end
    
    describe '編集画面' do
      before do
        visit edit_daily_record_path(daily_record)
      end
      
      context '表示の確認' do
        it '編集前の内容が表示されている' do
          expect(page).to have_field 'daily_record[theme]', with: '題名'
          expect(page).to have_field 'daily_record[introduction]', with: '内容'
          select(value = '食事', from: 'daily_record_genre')
        end
        
        it '更新ボタンが表示される' do
          expect(page).to have_button '変更を保存'
        end
      end
      
      context '動作の確認' do
        it '更新に成功しサクセスメッセージが表示されるか' do
          fill_in 'daily_record[theme]', with: '題名２'
          fill_in 'daily_record[introduction]', with: '内容２'
          select '運動', from: 'daily_record_genre'
          click_button '変更を保存'
          expect(page).to have_content '更新しました'
        end
        
        it '更新に失敗しエラーメッセージが表示されるか' do
          fill_in 'daily_record[theme]', with: ''
          fill_in 'daily_record[introduction]', with: ''
          select(value = '食事', from: 'daily_record[genre]')
          click_button '変更を保存'
          expect(page).to have_content '入力してください'
        end
        
        it '更新後のリダイレクト先は正しいか' do
          fill_in 'daily_record[theme]', with: '題名２'
          fill_in 'daily_record[introduction]', with: '内容２'
          select '運動', from: 'daily_record_genre'
          click_button '変更を保存'
          expect(page).to have_current_path daily_record_path(daily_record)
        end
      end
    end
    
    describe '一覧画面' do
      before do
        (1..4).each do |i|
          FactoryBot.create(:daily_record, theme: '題名テスト'+ i.to_s, introduction: '内容テスト'+ i.to_s, user: user)
        end
        visit daily_records_path
      end
      
      context '表示の確認' do
        it "daily_recordの題名・ジャンル・投稿者の表示がされているか" do
          DailyRecord.all.each_with_index do |daily_record|
            expect(page).to have_content daily_record.theme
            expect(page).to have_content daily_record.genre
            expect(page).to have_content daily_record.user.last_name
          end
        end
        
        it "詳細・投稿者マイページへのリンクが表示されているか" do
          DailyRecord.all.each_with_index do |daily_record|
            expect(page).to have_link(daily_record.theme, href: '/daily_records/' + daily_record.id.to_s)
            expect(page).to have_link(daily_record.user.last_name, href: '/users/' + daily_record.user_id.to_s)
          end
        end
      end

      context '動作の確認' do
        it '詳細リンクの遷移先確認' do
          DailyRecord.all.each_with_index do |daily_record, i|
            j = i * 2
            show_link = find_all('a')[22 - j]
  	        expect(show_link[:href]).to eq daily_record_path(daily_record)
  	      end
        end
        
        it '投稿者マイページリンクの遷移先確認' do
          DailyRecord.all.each_with_index do |daily_record, i|
            j = i * 2
            mypage_link = find_all('a')[23 - j]
  	        expect(mypage_link[:href]).to eq user_path(daily_record.user)
  	      end
        end
      end
    end
  end

  describe '個人利用者ログイン（本人以外）' do
    before do
      sign_in_as(user2)
    end

    describe '詳細画面' do
      before do
        visit daily_record_path(daily_record)
      end

      context '表示の確認' do
        it '日常記録の題名・内容・ジャンル名が表示されているか' do
          expect(page).to have_content daily_record.theme
          expect(page).to have_content daily_record.introduction
          expect(page).to have_content daily_record.genre
        end
        
        it '編集のリンクが表示されていないか' do
          expect(page).not_to have_link('編集する', href: '/daily_records/' + daily_record.id.to_s + '/edit')
        end
      end
    end

    describe '編集画面' do
      before do
        visit edit_daily_record_path(daily_record)
      end
      
      context '表示の確認' do
        it '自分のマイページへ遷移させられている' do
          expect(page).to have_content user2.first_name
        end
      end
    end

    describe '一覧画面（本人以外の投稿）' do
      before do
        (1..4).each do |i|
          FactoryBot.create(:daily_record, theme: '題名テスト'+ i.to_s, introduction: '内容テスト'+ i.to_s, user: user)
        end
        visit daily_records_path
      end
      
      context '表示の確認' do
        it "daily_recordの題名・ジャンル・投稿者の表示がされているか" do
          DailyRecord.all.each_with_index do |daily_record|
            expect(page).to have_content daily_record.theme
            expect(page).to have_content daily_record.genre
            expect(page).to have_content daily_record.user.last_name
          end
        end
        
        it "詳細・投稿者マイページへのリンクが表示されているか" do
          DailyRecord.all.each_with_index do |daily_record|
            expect(page).to have_link(daily_record.theme, href: '/daily_records/' + daily_record.id.to_s)
            expect(page).to have_link(daily_record.user.last_name, href: '/users/' + daily_record.user_id.to_s)
          end
        end
      end
      
      context '動作の確認' do
        it '詳細リンクの遷移先確認' do
          DailyRecord.all.each_with_index do |daily_record, i|
            j = i * 2
            show_link = find_all('a')[22 - j]
  	        expect(show_link[:href]).to eq daily_record_path(daily_record)
  	      end
        end
        
        it '投稿者マイページリンクの遷移先確認' do
          DailyRecord.all.each_with_index do |daily_record, i|
            j = i * 2
            mypage_link = find_all('a')[23 - j]
  	        expect(mypage_link[:href]).to eq user_path(daily_record.user)
  	      end
        end
      end
    end
  end

  describe '医療関係者ログイン' do
    before do
      family_registration(user, hospital)
      sign_in_as_hospital(hospital)
    end
    
    describe '詳細画面' do
      before do
        visit daily_record_path(daily_record)
      end
      
      context '表示の確認' do
        it '日常記録の題名・内容・ジャンル名が表示されているか' do
          expect(page).to have_content daily_record.theme
          expect(page).to have_content daily_record.introduction
          expect(page).to have_content daily_record.genre
        end
        
        it '編集のリンクが表示されていないか' do
          expect(page).not_to have_link('編集する', href: '/daily_records/' + daily_record.id.to_s + '/edit')
        end
      end
    end

    describe '編集画面' do
      before do
        visit edit_daily_record_path(daily_record)
      end
      
      context '表示の確認' do
        it '自分のマイページへ遷移させられている' do
          expect(page).to have_content hospital.name
        end
      end
    end

    describe '新規登録画面' do
      before do
        visit new_daily_record_path
      end

      context '表示の確認' do
        it '自分のマイページへ遷移させられている' do
          expect(page).to have_content hospital.name
        end
      end
    end
  end
end