module GuestUserManagement
  extend ActiveSupport::Concern

  included do
    before_action :create_guest_family_data, only: :login_as_guest
  end

  def create_guest_family_data
    @family = Family.create(family_name: 'ゲスト', family_nickname: 'ゲストファミリー', budget: 100_000,
                            budget_of_last_month: 75_000, status: :guest)
    family = @family
    papa = User.create(family_id: family.id, name: 'ゲス太郎', nickname: 'パパ', email: fake_email,
                       password: "#{ENV['GUEST_PASSWORD']}", password_confirmation: "#{ENV['GUEST_PASSWORD']}")
    mom = User.create(family_id: family.id, name: 'ゲス華子', nickname: 'ママ', email: fake_email,
                      password: "#{ENV['GUEST_PASSWORD']}", password_confirmation: "#{ENV['GUEST_PASSWORD']}")
    user = User.create(family_id: family.id, name: 'ゲスト', nickname: 'ゲスト', email: fake_email,
                       password: "#{ENV['GUEST_PASSWORD']}", password_confirmation: "#{ENV['GUEST_PASSWORD']}")
    bros = User.create(family_id: family.id, name: 'ゲス弟', nickname: '次郎', email: fake_email,
                       password: "#{ENV['GUEST_PASSWORD']}", password_confirmation: "#{ENV['GUEST_PASSWORD']}")
    tasks = Task.where(family_id: family.id)

    TaskUser.create(task_id: tasks.find_by(title: '朝食の用意').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '出社・勤務開始').id, user_id: papa.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '出社・勤務開始').id, user_id: user.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '登校').id, user_id: bros.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '食事の後片付け').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '掃除機がけ').id, user_id: mom.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '夕食の用意').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '食事の後片付け').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '業務').id, user_id: user.id, family_id: family.id, count: 8)
    TaskUser.create(task_id: tasks.find_by(title: '業務').id, user_id: papa.id, family_id: family.id, count: 8)
    TaskUser.create(task_id: tasks.find_by(title: '残業').id, user_id: papa.id, family_id: family.id, count: 2)
    TaskUser.create(task_id: tasks.find_by(title: '授業1コマ').id, user_id: bros.id, family_id: family.id, count: 5)
    TaskUser.create(task_id: tasks.find_by(title: '部活：練習1時間').id, user_id: bros.id, family_id: family.id, count: 3)

    TaskUser.create(task_id: tasks.find_by(title: '朝食の用意').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '出社・勤務開始').id, user_id: papa.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '出社・勤務開始').id, user_id: user.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '登校').id, user_id: bros.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '食事の後片付け').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '掃除機がけ').id, user_id: mom.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '洗濯').id, user_id: mom.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '夕食の用意').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '業務').id, user_id: user.id, family_id: family.id, count: 8)
    TaskUser.create(task_id: tasks.find_by(title: '食事の後片付け').id, user_id: user.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '業務').id, user_id: papa.id, family_id: family.id, count: 8)
    TaskUser.create(task_id: tasks.find_by(title: '残業').id, user_id: papa.id, family_id: family.id, count: 3)
    TaskUser.create(task_id: tasks.find_by(title: '授業1コマ').id, user_id: bros.id, family_id: family.id, count: 6)
    TaskUser.create(task_id: tasks.find_by(title: '部活：練習1時間').id, user_id: bros.id, family_id: family.id, count: 2)
    TaskUser.create(task_id: tasks.find_by(title: '仕事の勉強').id, user_id: user.id, family_id: family.id, count: 2)

    TaskUser.create(task_id: tasks.find_by(title: '朝食の用意').id, user_id: papa.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '出社・勤務開始').id, user_id: papa.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '出社・勤務開始').id, user_id: user.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '登校').id, user_id: bros.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '食事の後片付け').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: 'ゴミ出し').id, user_id: mom.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '掃除機がけ').id, user_id: mom.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '洗濯').id, user_id: mom.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '夕食の用意').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '業務').id, user_id: user.id, family_id: family.id, count: 8)
    TaskUser.create(task_id: tasks.find_by(title: '残業').id, user_id: user.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '会議出席').id, user_id: user.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '食事の後片付け').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '業務').id, user_id: papa.id, family_id: family.id, count: 8)
    TaskUser.create(task_id: tasks.find_by(title: '会議発表').id, user_id: papa.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '授業1コマ').id, user_id: bros.id, family_id: family.id, count: 6)
    TaskUser.create(task_id: tasks.find_by(title: '部活：練習1時間').id, user_id: bros.id, family_id: family.id, count: 2)
    TaskUser.create(task_id: tasks.find_by(title: '仕事の勉強').id, user_id: user.id, family_id: family.id, count: 2)
    TaskUser.create(task_id: tasks.find_by(title: '数学').id, user_id: bros.id, family_id: family.id, count: 2)

    TaskUser.create(task_id: tasks.find_by(title: '朝食の用意').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '出社・勤務開始').id, user_id: papa.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '出社・勤務開始').id, user_id: user.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '登校').id, user_id: bros.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '食事の後片付け').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '買い出し').id, user_id: mom.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '掃除機がけ').id, user_id: mom.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '夕食の用意').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '業務').id, user_id: user.id, family_id: family.id, count: 8)
    TaskUser.create(task_id: tasks.find_by(title: '残業').id, user_id: user.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '食事の後片付け').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '業務').id, user_id: papa.id, family_id: family.id, count: 8)
    TaskUser.create(task_id: tasks.find_by(title: '授業1コマ').id, user_id: bros.id, family_id: family.id, count: 6)
    TaskUser.create(task_id: tasks.find_by(title: '部活：練習1時間').id, user_id: bros.id, family_id: family.id, count: 2)
    TaskUser.create(task_id: tasks.find_by(title: '仕事の勉強').id, user_id: user.id, family_id: family.id, count: 2)
    TaskUser.create(task_id: tasks.find_by(title: '英語').id, user_id: bros.id, family_id: family.id, count: 2)

    TaskUser.create(task_id: tasks.find_by(title: '朝食の用意').id, user_id: user.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '食事の後片付け').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '掃除機がけ').id, user_id: papa.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '昼食の用意').id, user_id: mom.id, family_id: family.id, count: 3)
    TaskUser.create(task_id: tasks.find_by(title: '洗濯').id, user_id: papa.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '食事の後片付け').id, user_id: user.id, family_id: family.id, count: 3)
    TaskUser.create(task_id: tasks.find_by(title: '仕事の勉強').id, user_id: user.id, family_id: family.id, count: 6)
    TaskUser.create(task_id: tasks.find_by(title: '部活：大会').id, user_id: bros.id, family_id: family.id)
    TaskUser.create(task_id: tasks.find_by(title: '夕食の用意').id, user_id: papa.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '食事の後片付け').id, user_id: mom.id, family_id: family.id, count: 4)
    TaskUser.create(task_id: tasks.find_by(title: '虫退治').id, user_id: bros.id, family_id: family.id)

    family.users.each do |member|
      member.update_column(:points, member.calculate_points)
      member.update_column(:pocket_money, member.calculate_pocket_money)
    end
  end

  def fake_email
    fake_email = "#{SecureRandom.urlsafe_base64}@example.com"
    fake_email = "#{SecureRandom.urlsafe_base64}@example.com" while User.find_by(email: fake_email).present?
    fake_email
  end
end
