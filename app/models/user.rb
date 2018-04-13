class User < ActiveRecord::Base
  include ActionView::Helpers
  has_many :emails, dependent: :destroy
  has_many :labels, dependent: :destroy
  has_many :drafts, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_secure_password
  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}
end
