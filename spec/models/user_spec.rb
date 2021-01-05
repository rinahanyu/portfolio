require 'rails_helper'

RSpec.describe User, type: :model do
  describe '個人利用者のモデルテスト' do
    let(:user_a) {FactoryBot.create(:user)}

    context "データが正しく保存される" do
      it "全て入力してあるので保存される" do
        expect(user_a).to be_valid
      end
    end

    context "データが正しく保存されない" do
      before do
        @user = FactoryBot.build(:user, last_name: "",  first_name: "", last_name_kana: "", first_name_kana: "", address: "", email: "", telphone_number: "", postal_code: "", password: "")
        @user.valid?
      end

      it "姓・名・セイ・メイ・メールアドレス・郵便番号・住所・電話番号・パスワードが入力されていないので保存されない" do
        expect(@user).to be_invalid
        expect(@user.errors[:last_name]).to include("を入力してください")
        expect(@user.errors[:first_name]).to include("を入力してください")
        expect(@user.errors[:last_name_kana]).to include("を入力してください")
        expect(@user.errors[:first_name_kana]).to include("を入力してください")
        expect(@user.errors[:address]).to include("を入力してください")
        expect(@user.errors[:email]).to include("を入力してください")
        expect(@user.errors[:telphone_number]).to include("は数値で入力してください")
        expect(@user.errors[:postal_code]).to include("は数値で入力してください")
        expect(@user.errors[:password]).to include("を入力してください")
      end
    end
  end
end
