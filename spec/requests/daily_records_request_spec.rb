require 'rails_helper'

RSpec.describe "DailyRecords", type: :request do
  describe '新規投稿ページ' do
    context "新規投稿ページが正しく表示される" do
      before do
        get new_daily_record_path
      end

      it 'リクエストは200 OKとなること' do
        expect(response.status).to eq 200
      end
      # 上記はbefore_actionを外して成功
      it 'タイトルが正しく表示されていること' do
        expect(response.body).to include("新規登録")
      end
    end
  end

  describe '一覧ページ' do
    context "一覧ページが正しく表示される" do
      before do
        get daily_records_path
      end

      it 'リクエストは200 OKとなること' do
        expect(response.status).to eq 200
      end
      # 上記はbefore_actionを外して成功
      it 'タイトルが正しく表示されていること' do
        expect(response.body).to include("みんなの投稿一覧")
      end
    end
  end

  describe '編集ページ' do
    context "編集ページが正しく表示される" do
      before do
        @daily_record = FactoryBot.create(:daily_record)
        get edit_daily_record_path(id: @daily_record.id)
      end

      it 'リクエストは200 OKとなること' do
        expect(response.status).to eq 200
      end
      # 上記はbefore_actionを外して成功
      it 'タイトルが正しく表示されていること' do
        expect(response.body).to include("編集")
      end
    end
  end
end
