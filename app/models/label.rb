class Label < ActiveRecord::Base
  belongs_to :user
  has_many   :emails, dependent: :nullify
  validates  :name, presence: true, length: { maximum: 10 }, uniqueness: { scope: :user_id }
  default_scope    -> { order(created_at: :asc) }
end
