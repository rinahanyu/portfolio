require 'rails_helper'

  describe "日常記録関連テスト" do
    let!(:user) {FactoryBot.create(:user)}
    let!(:daily_record) {FactoryBot.create(:daily_record, user: user)}

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: 'h@h'
      fill_in 'user[password]', with: 'password'
      click_button 'ログイン'
    end

    describe '新規登録画面のテスト' do
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

        it 'Create Bookボタンが表示される' do
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

    describe '詳細画面のテスト' do
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

        it '編集リンクの遷移先確認' do
          edit_link = find_all('a')[12]
	        edit_link.click
	        expect(current_path).to eq('/daily_records/' + daily_record.id.to_s + '/edit')
        end

        it '削除の確認' do
          expect{ daily_record.destroy }.to change{ DailyRecord.count }.by(-1)
        end
      end
    end
    # context 'book削除のテスト' do
    #   it 'bookの削除' do
    #     expect{ book.destroy }.to change{ Book.count }.by(-1)
    #     # ※本来はダイアログのテストまで行うがココではデータが削除されることだけをテスト
    #   end
    # end


  # it "bookの一覧表示(tableタグ)と投稿フォームが同一画面に表示されているか" do
  #   expect(page).to have_selector 'table'
  #   expect(page).to have_field 'book[title]'
  #   expect(page).to have_field 'book[body]'
  # end
  # it "bookのタイトルと感想を表示し、詳細・編集・削除のリンクが表示されているか" do
  #     (1..5).each do |i|
  #       Book.create(title:'hoge'+i.to_s,body:'body'+i.to_s)
  #     end
  #     visit books_path
  #     Book.all.each_with_index do |book,i|
  #       j = i * 3
  #       expect(page).to have_content book.title
  #       expect(page).to have_content book.body
  #       # Showリンク
  #       show_link = find_all('a')[j]
  #       expect(show_link.native.inner_text).to match(/show/i)
  #       expect(show_link[:href]).to eq book_path(book)
  #       # Editリンク
  #       show_link = find_all('a')[j+1]
  #       expect(show_link.native.inner_text).to match(/edit/i)
  #       expect(show_link[:href]).to eq edit_book_path(book)
  #       # Destroyリンク
  #       show_link = find_all('a')[j+2]
  #       expect(show_link.native.inner_text).to match(/destroy/i)
  #       expect(show_link[:href]).to eq book_path(book)
  #     end
  # end


  # describe '一覧ページ' do
  #   context "一覧ページが正しく表示される" do
  #     before do
  #       get daily_records_path
  #     end

  #     it 'リクエストは200 OKとなること' do
  #       expect(response.status).to eq 200
  #     end
  #     # 上記はbefore_actionを外して成功
  #     it 'タイトルが正しく表示されていること' do
  #       expect(response.body).to include("みんなの投稿一覧")
  #     end
  #   end
  # end

  # describe '編集ページ' do
  #   context "編集ページが正しく表示される" do
  #     before do
  #       @daily_record = FactoryBot.create(:daily_record)
  #       get edit_daily_record_path(id: @daily_record.id)
  #     end

  #     it 'リクエストは200 OKとなること' do
  #       expect(response.status).to eq 200
  #     end
  #     # 上記はbefore_actionを外して成功
  #     it 'タイトルが正しく表示されていること' do
  #       expect(response.body).to include("編集")
  #     end
  #   end
  end
