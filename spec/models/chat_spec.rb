require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe 'チャットのモデルテスト' do
    let(:user_a) {FactoryBot.create(:user)}
    let(:hospital_a) {FactoryBot.create(:hospital)}
    let(:room_a) {FactoryBot.create(:room, user: user_a, hospital: hospital_a)}
    let(:chat_a) {FactoryBot.create(:chat, user: user_a, hospital: hospital_a, room: room_a)}

    context "データが正しく保存される" do
      it "全て入力してあるので保存される" do
        expect(chat_a).to be_valid
      end
    end

    context "データが正しく保存されない" do
      before do
        @chat = FactoryBot.build(:chat, message: "", user: user_a, hospital: hospital_a, room: room_a)
        @chat.valid?
      end

      it "メッセージが入力されていないので保存されない" do
        expect(@chat).to be_invalid
      end
    end
  end
end
