require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー登録' do
    let(:user) { FactoryBot.build(:user) }

    context 'ユーザーが登録できるとき' do
      it 'emailとpasswordがあれば登録できる' do
        expect(user).to be_valid
      end
    end

    context 'ユーザーが登録できないとき' do
      it 'emailが空だと登録できない' do
        user.email = ''
        user.valid?
        expect(user.errors.added?(:email, :blank)).to be(true)
      end

      it 'emailが重複していると登録できない' do
        FactoryBot.create(:user, email: user.email)
        user.valid?
        expect(user).not_to be_valid
        expect(user.errors[:email]).to be_present
      end

      it 'passwordが空だと登録できない' do
        user.password = ''
        user.password_confirmation = ''
        user.valid?
        expect(user.errors.added?(:password, :blank)).to be(true)
      end

      it 'passwordが6文字未満だと登録できない' do
        user.password = '12345'
        user.password_confirmation = '12345'
        user.valid?
        expect(user.errors.added?(:password, :too_short, count: 6)).to be(true)
      end

      it 'password_confirmationが一致しないと登録できない' do
        user.password_confirmation = 'different_password'
        user.valid?
        expect(user.errors.added?(:password_confirmation, :confirmation, attribute: 'Password')).to be(true)
      end
    end
  end
end
