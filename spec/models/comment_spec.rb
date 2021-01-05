require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'コメントのモデルテスト' do
    let(:user_a) {FactoryBot.create(:user)}
    let(:daily_record_a) {FactoryBot.create(:daily_record, user: user_a)}
    let(:comment_a) {FactoryBot.create(:comment, user: user_a, daily_record: daily_record_a)}

    context "データが正しく保存される" do
      it "全て入力してあるので保存される" do
        expect(comment_a).to be_valid
      end
    end

    context "データが正しく保存されない" do
      before do
        @comment = FactoryBot.build(:comment, comment: "", user: user_a, daily_record: daily_record_a)
        @comment.valid?
      end

      it "コメントが入力されていないので保存されない" do
        expect(@comment).to be_invalid
      end
    end
  end
end
