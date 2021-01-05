require 'rails_helper'

RSpec.describe MedicalHistory, type: :model do
  describe '病歴のモデルテスト' do
    let(:user_a) {FactoryBot.create(:user)}
    let(:medical_history_a) {FactoryBot.create(:medical_history, user: user_a)}

    context "データが正しく保存される" do
      it "全て入力してあるので保存される" do
        expect(medical_history_a).to be_valid
      end
    end

    context "データが正しく保存される" do
      before do
        @medical_history_b = FactoryBot.create(:medical_history, finished_on: "", user: user_a)
      end

      it "治療終了日が入力されていなくても保存される" do
        expect(@medical_history_b).to be_valid
      end
    end

    context "データが正しく保存されない" do
      before do
        @medical_history = FactoryBot.build(:medical_history, disease: "",  started_on: "", treatment: "", hospital: "", user: user_a)
        @medical_history.valid?
      end

      it "傷病名・治療開始日・治療内容・治療先が入力されていないので保存されない" do
        expect(@medical_history).to be_invalid
        expect(@medical_history.errors[:disease]).to include("を入力してください")
        expect(@medical_history.errors[:started_on]).to include("を入力してください")
        expect(@medical_history.errors[:treatment]).to include("を入力してください")
        expect(@medical_history.errors[:hospital]).to include("を入力してください")
      end
    end
  end
end
