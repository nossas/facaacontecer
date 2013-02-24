class Subscription < ActiveRecord::Base
 
  # Attributes accessible on create! or update! 
  attr_accessible :subscriber_id, :code, :value, :project_id


  # Relationship with Projects and the correspondent user for each subscription 
  belongs_to :project
  belongs_to :subscriber, class_name: 'User'

  # This attributes should be present when creating an order
  validates_presence_of :value, :project_id, :subscriber_id, :code

  # Scope for completed payments
  scope :raised, where(status: :subscribed)

end
