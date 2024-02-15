require "rails_helper"

describe "タスク登録機能", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category, family: user.family) }
  let!(:task) { FactoryBot.create(:task, category: category) }
  it "taskが関連づけられたcategoryとfamilyを持っていること" do
    puts task.inspect
  end
  context "ログインして設定→タスク管理ボタンを押すと" do
    before do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password"
      click_button "ログイン"
      click_on "設定"
      click_on "タスク管理"
    end
    it "デフォルトでカテゴリと各ボタンが表示されている" do
      expect(page).to have_content "筋トレ"
      expect(page).to have_content "新規"
      expect(page).to have_content "編集"
      expect(page).to have_content "削除"
    end
    describe "正常系" do
      context "新規ボタンを押し、新しいカテゴリ名を入力して登録ボタンを押すと" do
        before do
          find(".btn-outline-primary").click
          fill_in "カテゴリ名", with: "ゼルダの伝説"
          click_button "登録する"
        end
        it "新しいカテゴリが追加される" do
          expect(page).to have_content "ゼルダの伝説"
        end
      end
      context "編集ボタンを押した時" do
        before do
          all(".btn-outline-success").first.click
        end
        it "タスク一覧が表示される" do
          expect(page).to have_content "朝食の用意"
        end
        context "さらに編集した時" do
          before do
            all(".text-success").first.click
            fill_in "基礎ポイント", with: 500
            click_button "更新する"
          end
          it "編集内容が反映される" do
            expect(page).to have_content "500"
          end
        end
        context "さらに削除したとき" do
          before do
            all(".text-danger").first.click
          end
          it "削除される" do
            expect(page.accept_confirm).to eq "ポイント取得履歴からも削除されます。本当に削除しますか？"
            expect(page).not_to have_content "朝食の用意"
          end
        end
      end
      context "削除ボタンを押したとき" do
        before do
          all(".btn-outline-danger").first.click
        end
        it "カテゴリが削除される" do
          expect(page.accept_confirm).to eq "このカテゴリに属するタスクも削除されます。よろしいですか？"
          expect(page).to have_content "【家事】が削除されました"
        end
      end
    end
  end
end
