class Invite < ActiveRecord::Base
  attr_accessible :code, :parent_user_id, :user_id

  belongs_to :user
  belongs_to :host, class_name: :User, foreign_key: :parent_user_id
end
