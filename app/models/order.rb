class Order < ActiveRecord::Base
  attr_accessible :address_one, :address_two, :city, :birthday,
                  :number, :state, :status, :token,
                  :zip, :name, :email, :country, 
                  :phone, :value, :cpf,
                  :address_number, :address_neighbourhood


  attr_readonly :uuid
  before_validation :generate_uuid!, on: :create

  belongs_to :project
  belongs_to :user

  validates_presence_of :name, :email, :birthday, :cpf, :address_one, :address_two, :address_number, :address_neighbourhood,
    :city, :state, :country, :zip, :phone, :value

  self.primary_key = 'uuid'

  # This is where we create our Payer Reference for MoIP Payments, and prefill some other information.

  def self.next_order_number
    Order.count > 0 ? Order.order("number DESC").limit(1).first.number.to_i + 1 : 1
  end

  def self.revenue
    self.current.zero? ? 0 : Order.sum(:value)
  end


  # Implement these three methods to
  def self.goal
    project = Project.first
    return project.goal if project.present?
  end

  def self.percent
    (self.current.to_f / self.goal.to_f) * 100.to_f
  end

  # See what it looks like when you have some backers! Drop in a number instead of Order.count
  def self.current
    Order.where("token != ? OR token != ?", "", nil).count
  end 

  def as_json(options ={})
    { 
      id:                     self.uuid,
      name:                   self.name,
      email:                  self.email,
      address_street:         self.address_one,
      address_street_extra:   self.address_two,
      address_street_number:  self.address_number,
      address_neighbourhood:  self.address_neighbourhood,
      address_city:           self.city,
      address_state:          self.state,
      address_country:        self.country,
      address_cep:            self.zip,
      address_phone:          self.phone
   }.merge(options)
  end


  def to_param
    self.uuid
  end



  def generate_uuid!
    begin
      self.uuid = SecureRandom.hex(16)
    end while Order.find_by_uuid(self.uuid).present?
  end


  def generate_payment_token!
    # Set up the payer for MoIP payment
    payer = MyMoip::Payer.new(self.as_json)

    # Create the payment instruction for the payer
    instruction = MyMoip::Instruction.new({
      id: SecureRandom.hex(8),
      payment_reason: "[Crowdfunding] #{self.email} - #{self.created_at}",
      values: [self.value.to_f],
      payer: payer
    })
      
    # Initialize a new transparent request
    transparent = MyMoip::TransparentRequest.new('crowdfunding')

    # Make the call to the MoIP API
    transparent.api_call(instruction)
    

    self.token = transparent.token
    self.save!
  end
end
