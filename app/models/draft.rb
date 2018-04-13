class Draft < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :username, :title, :user_id
  
  scope :newest,   -> { order(created_at: :desc) }
  scope :oldest,   -> { order(created_at: :asc) }
end
