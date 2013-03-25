class Invite < ActiveRecord::Base
  attr_accessible :code, :parent_user_id, :user_id
  belongs_to :user
end
