# coding: utf-8
describe Order do

  context "association" do
    it { should belong_to :project }
  end
  
  context "validations" do
    [
      :name, :email, :address_one, :address_two,
      :city, :state, :country, :zip, :phone, :birthday,
      :value, :cpf, :address_neighbourhood, :address_number
    ].each do |attribute|
      it { should validate_presence_of attribute }
    end
  end


  context "attributes" do

    [
     :address_one, :address_two, :city, :birthday,
      :number, :state, :status, :token,
      :zip, :name, :email, :country, 
      :phone, :value, :cpf,
      :address_number, :address_neighbourhood
    ].each do |property|
        it { should allow_mass_assignment_of property }
      end

      it { should_not allow_mass_assignment_of :uuid }

      it "generates UUID before validation on_create" do
        @order = Order.new
        @order.valid?
        @order.uuid.should_not be_nil
      end

      it { Order.primary_key.should == 'uuid' }

    end

  context "class methods" do

    describe ".next_order_number" do

      it "gives the next number" do
        ActiveRecord::Relation.any_instance.stub(:first).and_return(stub( number: 1 ))
        Order.next_order_number.should == 2
      end

      context "no orders" do

          before do
            ActiveRecord::Relation.any_instance.stub(:first).and_return(nil)
            Order.stub!(:count).and_return(0)
          end

          it "doesn't break if there's no orders" do
            expect { Order.next_order_number }.to_not raise_error
          end

          it "returns 1 if there's no orders" do
            Order.next_order_number.should == 1
          end
      end
    end

    describe ".percent" do
      it "calculates the percent based on #goal and #current" do
        Order.stub(:current).and_return(6.2)
        Order.stub(:goal).and_return(2.5)
  

        # 2.48 is due to 6.2/2.5 (current / goal)
        Order.percent.should == 2.48 * 100
      end
    end

    describe ".goal" do
      it "returns the project goal from Settings" do
        project = Project.make!
        Order.goal.should == project.goal
      end
    end

    describe ".revenue" do
      it "should return the sum of the column value of all orders if current is greater than ZERO" do
        Order.stub(:current).and_return(10)
        Order.stub(:sum).with(:value).and_return(50)
        Order.revenue.should == 50
      end

      it "should not return the sum of the column value of all orders if current is ZERO" do
        Order.stub(:sum).with(:value).and_return(50)
        Order.revenue.should_not == 50
      end
    end

    describe ".current" do
      it "returns the number of orders with valid token / that have been postfilled" do
      end
    end

  end
end
