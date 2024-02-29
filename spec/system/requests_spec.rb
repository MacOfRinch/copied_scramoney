require 'rails_helper'

describe '承認申請機能', type: :system do
  let!(:family) { FactoryBot.create(:family, :with_users) }
  let!(:another_family) { FactoryBot.create(:family, :another_family) }
  
  describe '正常系' do
    context '一人が承認申請した時' do
      before do
        login_by(family.users.first)
        click_on '設定'
        click_on '家族のプロフィール・お小遣い'
        click_on '編集'
        fill_in '名字', with: 'バーンデッド'
        fill_in 'お小遣い予算', with: 100000
        click_on '変更承認申請をする'
      end
      it '自分自身に通知がないこと' do
        all('.fa-bell').first.click
        expect(page).not_to have_content '家族プロフィール変更の承認依頼'
      end
      context 'さらに、承認者がログインした時' do
        before do
          logout_by(family.users.first)
        end
        it '全員に通知が来ていること' do
          family.users.each do |approver|
            next if approver == family.users.first
            login_by(approver)
            all('.fa-circle').first.click
            expect(page).to have_content '家族プロフィール変更の承認依頼'
            logout_by(approver)
          end
        end
      end
      context 'さらに、承認者が全員承認した場合' do
        before do
          logout_by(family.users.first)
          family.users.each do |approver|
            next if approver == family.users.first
            login_by(approver)
            all('.fa-circle').first.click
            click_on '家族プロフィール変更の承認依頼'
            sleep 0.5
            click_on '承認'
            logout_by(approver)
          end
        end
        it '家族プロフィールが変更されていること' do
          modified_family = Family.find(family.id)
          expect(modified_family.family_name).to eq 'バーンデッド'
          expect(modified_family.budget).to eq 100000
        end
      end
    end
  end
end

def login_by(user)
  visit login_path
  fill_in 'メールアドレス', with: user.email
  fill_in 'パスワード', with: 'password'
  click_button 'ログイン'
end

def logout_by(user)
  visit family_configuration_path(family)
  page.accept_confirm { click_button 'ログアウト' }
end