class Order < ActiveRecord::Base
  attr_accessible :address_one, :address_two, :city, :country, 
                  :number, :state, :status, :token,
                  :zip, :name, :email,
                  :phone, :value, :cpf,
                  :address_number, :address_neighbourhood


  attr_readonly :uuid
  before_validation :generate_uuid!, :on => :create

  belongs_to :project
  belongs_to :user

  validates_presence_of :name, :email, :cpf, :address_one, :address_two, :address_number, :address_neighbourhood,
    :city, :state, :country, :zip, :phone, :value

  self.primary_key = 'uuid'

  # This is where we create our Payer Reference for MoIP Payments, and prefill some other information.
  def self.prefill!(options = {})
    @order                = Order.new
    @order.name           = options[:name]
    @order.project        = options[:project]
    @order.email          = options[:email]
    @order.address_one    = options[:address_one]
    @order.address_two    = options[:address_two]
    @order.address_number = options[:address_number]
    @order.address_neighbourhood    = options[:address_neighbourhood]
    @order.cpf            = options[:cpf]
    @order.city           = options[:city]
    @order.state          = options[:state]
    @order.zip            = options[:zip]
    @order.phone          = options[:phone]
    @order.country        = options[:country]
    @order.value          = options[:value]
    @order.number         = Order.next_order_number
    @order.save!
    return @order
  end

  # After authenticating with Amazon, we get the rest of the details
  def self.postfill!(options = {})
    @order = Order.find_by_uuid!(options[:payer])
    @order.token = options[:token]
    @order.save! if @order.token.present?
  end

  def self.next_order_number
    Order.count > 0 ? Order.order("number DESC").limit(1).first.number.to_i + 1 : 1
  end

  def generate_uuid!
    begin
      self.uuid = SecureRandom.hex(16)
    end while Order.find_by_uuid(self.uuid).present?
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

end
