namespace :past_data do
  desc '過去のデータを削除するよ。'
  task delete: :environment do
    now = Time.current
    start_of_last_month = now.prev_month.beginning_of_month

    Notice.where('created_at < ?', start_of_last_month).delete_all
    TaskUser.where('created_at < ?', start_of_last_month).delete_all
    ApprovalRequest.where('created_at < ?', start_of_last_month).delete_all
    ApprovalStatus.where('created_at < ?', start_of_last_month).delete_all
    Read.where('created_at < ?', start_of_last_month).delete_all
    TemporaryFamilyDatum.where('created_at < ?', start_of_last_month).delete_all
  end
end
