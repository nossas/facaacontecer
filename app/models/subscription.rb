class Subscription < ActiveRecord::Base
 
  # Attributes accessible on create! or update! 
  attr_accessible :code, :value, :gift, :anonymous


  # Relationship with Projects and the correspondent user for each subscription 
  belongs_to :project
  belongs_to :subscriber, class_name: 'User'

  # This attributes should be present when creating an order
  validates_presence_of :value, :project, :subscriber, :code

  # Scope for completed payments
  scope :raised, where(status: :subscribed)

end
