class Subscription < ActiveRecord::Base
 

  # Attributes accessible on create! or update! 
  attr_accessible :code, :value, :gift, :anonymous


  # Relationship with Projects and the correspondent user for each subscription 
  belongs_to :project
  belongs_to :subscriber, class_name: 'User'

  # This attributes should be present when creating an order
  validates_presence_of :value, :project, :subscriber, :code

  # Scope for completed payments
  scope :raised, where(status: :active)



  def self.find_and_update_status(options)
    self.find_by_code(options[:resource][:code].to_s) do |s|
      s.status = options[:resource][:status].downcase
      s.save!
    end
  end
end
