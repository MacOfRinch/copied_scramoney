class Read < ApplicationRecord
  # 中間テーブルだよ。既読・未読判定をするよ。
  belongs_to :notice
  belongs_to :user
end
