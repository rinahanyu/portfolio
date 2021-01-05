require 'rails_helper'

RSpec.describe HealthCare, type: :model do
   describe '健康管理のモデルテスト' do
    let(:user_a) {FactoryBot.create(:user)}
    let(:health_care_a) {FactoryBot.create(:health_care, user: user_a)}

    context "データが正しく保存される" do
      it "全て入力してあるので保存される" do
        expect(health_care_a).to be_valid
      end

      context "体重が入力してあるので保存される" do
        before do
          @health_care_b = FactoryBot.create(:health_care, max_blood_pressure: "", min_blood_pressure: "", blood_sugar: "",  user: user_a)
        end
        it "全て入力してあるので保存される" do
          expect(@health_care_b).to be_valid
        end
      end

      context "最高血圧が入力してあるので保存される" do
        before do
          @health_care_c = FactoryBot.create(:health_care, body_weight: "", min_blood_pressure: "", blood_sugar: "",  user: user_a)
        end
        it "全て入力してあるので保存される" do
          expect(@health_care_c).to be_valid
        end
      end

      context "最低血圧が入力してあるので保存される" do
        before do
          @health_care_d = FactoryBot.create(:health_care, body_weight: "", max_blood_pressure: "", blood_sugar: "",  user: user_a)
        end
        it "全て入力してあるので保存される" do
          expect(@health_care_d).to be_valid
        end
      end

      context "血糖値が入力してあるので保存される" do
        before do
          @health_care_e = FactoryBot.create(:health_care, body_weight: "",  max_blood_pressure: "", min_blood_pressure: "", user: user_a)
        end
        it "全て入力してあるので保存される" do
          expect(@health_care_e).to be_valid
        end
      end

    end

    context "データが正しく保存されない" do
      before do
        @health_care = FactoryBot.build(:health_care, body_weight: "",  max_blood_pressure: "", min_blood_pressure: "", blood_sugar: "", date: "", user: user_a)
        @health_care.valid?
      end

      it "体重・最高血圧・最低血圧・血糖値・日付が入力されていないので保存されない" do
        expect(@health_care).to be_invalid
        expect(@health_care.errors[:body_weight_or_max_blood_pressure_or_min_blood_pressure_or_blood_sugar]).to include("体重・最高血圧・最低血圧・血糖値のいずれかを入力してください")
        expect(@health_care.errors[:date]).to include("を入力してください")
      end
    end
  end
end
