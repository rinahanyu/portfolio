require 'rails_helper'

RSpec.describe DailyRecord, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end

  context "データが正しく保存される" do
    before do
      @daily_record = FactoryBot.create(:daily_record, user: @user)
    end

    it "全て入力してあるので保存される" do
      expect(@daily_record).to be_valid
    end
  end

  context "データが正しく保存されない" do
    before do
      @daily_record_a = FactoryBot.build(:daily_record, theme: "", introduction: "", user: @user)
      @daily_record_a.valid?
    end

    it "theme, introductionが入力されていないので保存されない" do
      expect(@daily_record_a).to be_invalid
      expect(@daily_record_a.errors[:theme]).to include("を入力してください")
      expect(@daily_record_a.errors[:introduction]).to include("を入力してください")
    end
  end
end
