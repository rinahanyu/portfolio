require 'rails_helper'

RSpec.describe MedicalRecord, type: :model do
  describe '診療記録のモデルテスト' do
    let(:user_a) {FactoryBot.create(:user)}
    let(:hospital_a) {FactoryBot.create(:hospital)}
    let(:medical_record_a) {FactoryBot.create(:medical_record, user: user_a, hospital: hospital_a)}

    context "データが正しく保存される" do
      it "全て入力してあるので保存される" do
        expect(medical_record_a).to be_valid
      end
    end

    context "データが正しく保存されない" do
      before do
        @medical_record = FactoryBot.build(:medical_record, start_time: "", doctor: "", disease: "",  treatment: "", user: user_a, hospital: hospital_a)
        @medical_record.valid?
      end

      it "診察日・医師名・傷病名・診察内容が入力されていないので保存されない" do
        expect(@medical_record).to be_invalid
        expect(@medical_record.errors[:start_time]).to include("を入力してください")
        expect(@medical_record.errors[:doctor]).to include("を入力してください")
        expect(@medical_record.errors[:disease]).to include("を入力してください")
        expect(@medical_record.errors[:treatment]).to include("を入力してください")
      end
    end
  end
end
