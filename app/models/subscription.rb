class Subscription < ActiveRecord::Base
 
  # Attributes accessible on create! or update! 
  attr_accessible :value, :token
  
  
  # We are creating Universally Unique Ids for each order
  before_validation :generate_uuid!, on: :create


  # Relationship with Projects and the correspondent user for each order
  belongs_to :project
  belongs_to :user

  # This attributes should be present when creating an order
  validates_presence_of :value, :project, :user

  # Scope for completed payments
  scope :raised, where('token IS NOT NULL')

  # We don't people to reassign uuids
  attr_readonly :uuid
  


  private
    # Generating unique UUID using the 1.9.3 Standard lib
    def generate_uuid!
      self.uuid = SecureRandom.uuid 
    end

end
