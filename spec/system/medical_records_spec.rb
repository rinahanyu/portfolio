require 'rails_helper'

describe "診療記録関連テスト" do
  let!(:user) {FactoryBot.create(:user)}
  let!(:hospital) {FactoryBot.create(:hospital)}
  let!(:medical_record) {FactoryBot.create(:medical_record, user: user, hospital: hospital)}

  before do
    family_registration(user, hospital)
    sign_in_as(hospital)
  end

  describe '新規登録画面' do
    before do
      visit new_user_medical_record_path(user)
    end

    context '表示の確認' do
      it "投稿フォームが表示される" do
        expect(page).to have_content '診療記録の新規登録'
        expect(page).to have_select 'medical_record[start_time(1i)]'
        expect(page).to have_select 'medical_record[start_time(2i)]'
        expect(page).to have_select 'medical_record[start_time(3i)]'
        expect(page).to have_field 'medical_record[doctor]'
        expect(page).to have_field 'medical_record[disease]'
        expect(page).to have_field 'medical_record[treatment]'
      end

      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context '投稿処理に関するテスト' do
      it '投稿に成功しサクセスメッセージが表示されるか' do
        select '2021', from: 'medical_record_start_time_1i'
        select '1', from: 'medical_record_start_time_2i'
        select '1', from: 'medical_record_start_time_3i'
        fill_in 'medical_record[doctor]', with: '医師名'
        fill_in 'medical_record[disease]', with: '傷病名'
        fill_in 'medical_record[treatment]', with: '診察内容'
        click_button '新規登録'
        expect(page).to have_content '投稿しました'
      end

      it '投稿に失敗する' do
        click_button '新規登録'
        expect(page).to have_content '医師名を入力してください'
        expect(page).to have_content '傷病名を入力してください'
        expect(page).to have_content '診察内容を入力してください'
        expect(current_path).to eq('/users/' + user.id.to_s + '/medical_records')
      end

      it '投稿後のリダイレクト先は正しいか' do
        select '2021', from: 'medical_record_start_time_1i'
        select '1', from: 'medical_record_start_time_2i'
        select '1', from: 'medical_record_start_time_3i'
        fill_in 'medical_record[doctor]', with: '医師名'
        fill_in 'medical_record[disease]', with: '傷病名'
        fill_in 'medical_record[treatment]', with: '診察内容'
        click_button '新規登録'
        expect(page).to have_current_path user_medical_records_path(user)
      end
    end
  end

  describe '詳細画面' do
    before do
      visit user_medical_record_path(user, medical_record)
    end

    context '表示の確認' do
      it '診察日・医師名・傷病名・診察内容が表示されているか' do
        expect(page).to have_content medical_record.start_time.strftime("%Y年%m月%d日")
        expect(page).to have_content medical_record.doctor
        expect(page).to have_content medical_record.disease
        expect(page).to have_content medical_record.treatment
      end

      it '編集のリンクが表示されているか' do
        expect(page).to have_link('編集', href: '/users/' + user.id.to_s + '/medical_records/' + medical_record.id.to_s + '/edit')
      end
    end

    context '動作の確認' do
      it '編集リンクの遷移先確認' do
        edit_link = find_all('a')[7]
        edit_link.click
        expect(page).to have_current_path edit_user_medical_record_path(user, medical_record)
      end

      it '削除の確認' do
        expect{ medical_record.destroy }.to change{ MedicalRecord.count }.by(-1)
      end

      it '削除に成功しメッセージが表示される' do
        destroy_link = find_all('a')[8]
        destroy_link.click
        expect(page).to have_content '削除しました'
      end
    end
  end

  describe '編集画面' do
    before do
      visit edit_user_medical_record_path(user, medical_record)
    end

    context '表示の確認' do
      it '編集前の内容が表示されている' do
        select(value = '2021', from: 'medical_record_start_time_1i')
        select(value = '1', from: 'medical_record_start_time_2i')
        select(value = '1', from: 'medical_record_start_time_3i')
        expect(page).to have_field 'medical_record[doctor]', with: '医師名'
        expect(page).to have_field 'medical_record[disease]', with: '傷病名'
        expect(page).to have_field 'medical_record[treatment]', with: '診察内容'
      end
      it '更新ボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
    end

    context '動作の確認' do
      it '更新に成功しサクセスメッセージが表示されるか' do
        select '2021', from: 'medical_record_start_time_1i'
        select '1', from: 'medical_record_start_time_2i'
        select '1', from: 'medical_record_start_time_3i'
        fill_in 'medical_record[doctor]', with: '医師名あ'
        fill_in 'medical_record[disease]', with: '傷病名あ'
        fill_in 'medical_record[treatment]', with: '診察内容あ'
        click_button '変更を保存'
        expect(page).to have_content '更新しました'
      end

      it '更新に失敗しエラーメッセージが表示されるか' do
        select '', from: 'medical_record_start_time_1i'
        select '', from: 'medical_record_start_time_2i'
        select '', from: 'medical_record_start_time_3i'
        fill_in 'medical_record[doctor]', with: ''
        fill_in 'medical_record[disease]', with: ''
        fill_in 'medical_record[treatment]', with: ''
        click_button '変更を保存'
        expect(page).to have_content '診察日を入力してください'
        expect(page).to have_content '医師名を入力してください'
        expect(page).to have_content '傷病名を入力してください'
        expect(page).to have_content '診察内容を入力してください'
      end

      it '更新後のリダイレクト先は正しいか' do
        select '2021', from: 'medical_record_start_time_1i'
        select '1', from: 'medical_record_start_time_2i'
        select '1', from: 'medical_record_start_time_3i'
        fill_in 'medical_record[doctor]', with: '医師名あ'
        fill_in 'medical_record[disease]', with: '傷病名あ'
        fill_in 'medical_record[treatment]', with: '診察内容あ'
        click_button '変更を保存'
        expect(page).to have_current_path user_medical_record_path(user, medical_record)
      end
    end
  end

  describe '一覧画面' do
    before do
      (1..4).each do |i|
        FactoryBot.create(:medical_record, start_time: '2021-01-01', doctor: '医師名テスト'+ i.to_s,
        disease: '傷病名テスト'+ i.to_s, treatment: '診察内容テスト'+ i.to_s, user: user, hospital: hospital)
      end
      visit user_medical_records_path(user)
    end

    context '表示の確認' do
      it "医療機関名・診察日・医師名・傷病名の表示がされているか" do
        MedicalRecord.all.each_with_index do |medical_record|
          expect(page).to have_content hospital.name
          expect(page).to have_content medical_record.start_time.strftime("%Y年%m月%d日")
          expect(page).to have_content medical_record.doctor
          expect(page).to have_content medical_record.disease
        end
      end
      it "詳細へのリンクが表示されているか" do
        MedicalRecord.all.each_with_index do |medical_record|
          expect(page).to have_link('詳細', href: '/users/' + user.id.to_s + '/medical_records/' + medical_record.id.to_s)
        end
      end
      it "新規作成へのリンクが表示されているか" do
        expect(page).to have_link('新規作成はこちらから！', href: '/users/' + user.id.to_s + '/medical_records/new')
      end
    end

    context '動作の確認' do
      it '詳細リンクの遷移先確認' do
        MedicalRecord.all.each_with_index do |medical_record, i|
          show_link = find_all('a')[15 + i]
	        expect(show_link[:href]).to eq user_medical_record_path(user, medical_record)
	      end
      end
    end
  end
end