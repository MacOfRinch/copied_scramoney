require 'rails_helper'

describe 'ログイン機能', type: :system do
  describe '基本機能' do
    let(:user) { FactoryBot.create(:user) }
    it 'userが関連付けられたfamilyを持っていること' do
      puts user.family.inspect
    end
    context 'ログインパスにアクセスした時' do
      before do
        visit login_path
      end
      it 'ログインページが表示される' do
        expect(page).to have_content 'ログイン'
      end
    end
    context '正しいメールアドレスとパスワードを打ち込んだ時' do
      before do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end
      it 'ログインに成功する' do
        expect(page).to have_content 'ログインに成功しました'
      end
    end
    context '違うメールアドレスとパスワードを打ち込んだ時' do
      before do
        visit login_path
        fill_in 'メールアドレス', with: 'tako@example.com'
        fill_in 'パスワード', with: 'ika'
        click_button 'ログイン'
      end
      it 'ログインに失敗する' do
        expect(page).to have_content 'ログインに失敗しました'
      end
    end
  end
end
