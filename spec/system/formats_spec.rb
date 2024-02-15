require "rails_helper"

describe "新規登録機能", type: :system do
  describe "正常系" do
    context "値を入力したとき" do
      before do
        visit new_format_path
        signup_right
      end
      it "招待画面に飛ぶ" do
        expect(page).to have_content "このページは、設定→家族の招待でいつでも表示できます。"
      end
    end
  end
  describe "異常系" do
    context "値の入力漏れがあったとき" do
      before do
        visit new_format_path
        signup_wrong
      end
      it "エラーメッセージが出て画面遷移しない" do
        expect(page).to have_content "入力内容に誤りがあります"
        expect(current_path).to eq new_format_path
      end
    end
  end
end

def signup_right
  fill_in "名字(必須)", with: "バーンデッド"
  fill_in "お小遣い予算(必須)", with: 50000
  fill_in "名前(必須)", with: "マッシュ"
  fill_in "メールアドレス(次回ログイン時に必要です)", with: "baka@example.com"
  fill_in "パスワード(次回ログイン時に必要です)", with: "password"
  fill_in "パスワードの確認", with: "password"
  click_button "ステップ1を完了する"
end

def signup_wrong
  fill_in "お小遣い予算(必須)", with: 50000
  fill_in "メールアドレス(次回ログイン時に必要です)", with: "baka@example.com"
  fill_in "パスワード(次回ログイン時に必要です)", with: "password"
  fill_in "パスワードの確認", with: "password"
  click_button "ステップ1を完了する"
end