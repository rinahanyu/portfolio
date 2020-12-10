require 'rails_helper'

RSpec.describe DailyRecord, type: :model do
  context "データが正しく保存される" do
    before do
      @daily_record = DailyRecord.new
      @daily_record.user_id = 1
      @daily_record.theme = "題名"
      @daily_record.introduction = "内容"
      @daily_record.genre = 0
      @daily_record.save
    end

    it "全て入力してあるので保存される" do
      expect(@daily_record).to be_valid
    end
  end

  context "データが正しく保存されない" do
    before do
      @daily_record = DailyRecord.new
      @daily_record.user_id = 1
      @daily_record.genre = 0
      @daily_record.save
    end

    it "theme, introductionが入力されていないので保存されない" do
      expect(@daily_record).to be_invalid
      expect(@daily_record.errors[:theme]).to include("を入力してください")
      expect(@daily_record.errors[:introduction]).to include("を入力してください")
    end
  end
  # belongs_to :userを外して成功
end
