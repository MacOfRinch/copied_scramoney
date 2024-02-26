require 'rails_helper'

describe 'タスク記録機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  context 'ログインパスにアクセスした時' do
    before do
      visit login_path
    end
    it 'ログインページが表示される' do
      expect(page).to have_content 'ログイン'
    end
    context 'ゲストログインを押すと' do
      before do
        click_button 'ゲストとしてログイン'
      end
      it 'デフォルトで四人家族のゲストとしてログインできる' do
        expect(page).to have_content 'ゲストファミリー'
      end
    end
    describe '通常ログイン' do
      before do
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
      end
      context '下部メニューの「記録」を押すと' do
        before do
          click_on '記録'
        end
        it 'デフォルトのカテゴリが一覧表示されている' do
          expect(page).to have_content '家事'
          expect(page).to have_content '仕事'
          expect(page).to have_content '勉強(仕事・資格)'
          expect(page).to have_content '学校'
          expect(page).to have_content '勉強(学校)'
          expect(page).to have_content 'ペット'
          expect(page).to have_content 'その他'
        end
        context 'カテゴリをクリックすると' do
          before do
            click_on '家事'
          end
          it 'カテゴリが展開される' do
            expect(page).to have_content '朝食の用意'
            expect(page).to have_content '昼食の用意'
            expect(page).to have_content '夕食の用意'
          end
          context '+ボタンを押して記録ボタンを押すと' do
            before do
              all('.btn-outline-primary').first.click
              all('.btn-outline-primary').first.click
              all('.btn-outline-primary')[1].click
              click_button '家事 を記録'
            end
            it '履歴ページに遷移し、複数回のタスクが記録されている' do
              expect(page).to have_selector '.alert-success', text: 'タスクを記録しました！'
              expect(page).to have_content '朝食の用意 x 2'
              expect(page).to have_content '昼食の用意'
            end
          end
          context '-ボタンを押すと' do
            context 'カウントが0のときは' do
              before do
                all('.btn-outline-danger').first.click
              end
              it 'カウントが変動しない' do
                expect(page).not_to have_content '-1'
              end
            end
            context 'カウントが1以上のときは' do
              before do
                all('.btn-outline-primary').first.click
                all('.btn-outline-primary').first.click
                all('.btn-outline-primary').first.click
                all('.btn-outline-primary').first.click
                all('.btn-outline-danger').first.click
              end
              it 'カウントが減る' do
                expect(page).to have_content '3'
              end
            end
          end
        end
      end
    end
  end
end
