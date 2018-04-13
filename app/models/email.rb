class Email < ActiveRecord::Base
  belongs_to :user
  belongs_to :interlocutor, class_name: 'User', foreign_key: 'interlocutor_id'
  belongs_to :label
  validates_presence_of :title, :message, :username, :user_id
  default_scope { where(trash: false) }
  scope :trash,    -> { unscope(where: :trash).where(trash: true) }
  scope :sent,     -> { where(message_type: 'sent') }
  scope :received, -> { where(message_type: 'received') }
  scope :newest,   -> { order(created_at: :desc) }
  scope :oldest,   -> { order(created_at: :asc) }
end
