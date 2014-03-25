class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :host, class_name: :User, foreign_key: :parent_user_id

  validates_presence_of :user_id, :code
end
