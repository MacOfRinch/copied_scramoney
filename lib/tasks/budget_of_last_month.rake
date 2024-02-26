namespace :budget_of_last_month do
  desc '先月末のお小遣い総額を保存して、ユーザー情報を先月に渡した上でリセットするよ。'
  task get: :environment do
    families = Family.all
    families.each do |family|
      family.update_column(:budget_of_last_month, family.budget)
      family.users.each do |user|
        user.update_columns(points_of_last_month: user.points,
                            pocket_money_of_last_month: user.pocket_money)
        user.update_column(:points, 0)
        user.update_column(:pocket_money, user.calculate_pocket_money)
      end
    end
  end
end
