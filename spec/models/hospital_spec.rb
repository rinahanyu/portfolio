require 'rails_helper'

RSpec.describe Hospital, type: :model do
  describe '医療関係者のモデルテスト' do
    let(:hospital_a) {FactoryBot.create(:hospital)}

    context "データが正しく保存される" do
      it "全て入力してあるので保存される" do
        expect(hospital_a).to be_valid
      end
    end

    context "データが正しく保存されない" do
      before do
        @hospital = FactoryBot.build(:hospital, name: "", address: "", email: "", telphone_number: "", postal_code: "", password: "")
        @hospital.valid?
      end

      it "医療機関名・メールアドレス・郵便番号・住所・電話番号・パスワードが入力されていないので保存されない" do
        expect(@hospital).to be_invalid
        expect(@hospital.errors[:name]).to include("を入力してください")
        expect(@hospital.errors[:address]).to include("を入力してください")
        expect(@hospital.errors[:email]).to include("を入力してください")
        expect(@hospital.errors[:telphone_number]).to include("は数値で入力してください")
        expect(@hospital.errors[:postal_code]).to include("は数値で入力してください")
        expect(@hospital.errors[:password]).to include("を入力してください")
      end
    end
  end
end
