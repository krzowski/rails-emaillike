class Contact < ActiveRecord::Base
  belongs_to :user
  validates  :name, presence: true, uniqueness: { case_sensitive: false }
  default_scope { order("lower(name) asc") }
end
