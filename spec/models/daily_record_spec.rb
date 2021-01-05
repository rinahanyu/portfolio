require 'rails_helper'

RSpec.describe DailyRecord, type: :model do
  describe '日常記録のモデルテスト' do
    let(:user_a) {FactoryBot.create(:user)}
    let(:daily_record_a) {FactoryBot.create(:daily_record, user: user_a)}

    context "データが正しく保存される" do
      it "全て入力してあるので保存される" do
        expect(daily_record_a).to be_valid
      end
    end

    context "データが正しく保存されない" do
      before do
        @daily_record = FactoryBot.build(:daily_record, theme: "", introduction: "", user: user_a)
        @daily_record.valid?
      end

      it "theme, introductionが入力されていないので保存されない" do
        expect(@daily_record).to be_invalid
        expect(@daily_record.errors[:theme]).to include("を入力してください")
        expect(@daily_record.errors[:introduction]).to include("を入力してください")
      end
    end
  end
end
