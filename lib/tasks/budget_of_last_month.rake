namespace :budget_of_last_month do
  desc '先月末のお小遣い総額を保存しておくよ。毎月末に定期実行するつもりだよ。'
  task get: :environment do
    families = Family.all
    families.each do |family|
      family.update_column(:budget_of_last_month, family.budget)
      users = family.users
      users.each do |user|
        user.update_columns(pocket_money_of_last_month: user.pocket_money, points_of_last_month: user.points)
      end
    end
  end
end
