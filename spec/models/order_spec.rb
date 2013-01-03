# coding: utf-8
describe Order do

  context "association" do
    it { should belong_to :project }
  end
  
  context "validations" do
    [
      :name, :email, :address_one, :address_two,
      :city, :state, :country, :zip, :phone, 
      :value, :cpf, :address_neighbourhood, :address_number
    ].each do |attribute|
      it { should validate_presence_of attribute }
    end
  end


  context "attributes" do

    [
      :address_one, :address_two, :city, :country, 
      :number, :state, :status, :token,
      :zip, :name, :price, 
      :phone, :value
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

    describe ".prefill!" do

      before do
        @project = Project.make!
        @options = {
          name: 'marin',
          email: 'juca@juca.com',
          cpf: '2312312313',
          project: @project,
          phone:  '2197137471',
          price: 10,
          address_one: "Minha rua",
          address_two: "Proximo àlgum lugar",
          address_number: "100",
          address_neighbourhood: "Laranjeiras",
          city: 'rio',
          state: 'rj',
          zip: '22234230',
          country: 'bra',
          value: 10
        }
      end

      subject { Order.prefill!(@options) }


      it "sets the name" do
        subject.name.should == @options[:name]
      end

      it "sets the project" do
        subject.project.should == @options[:project]
      end

      it "sets the value" do
        subject.value.should == @options[:value]
      end

      it "saves" do
        Order.any_instance.should_receive :save!
        Order.prefill!(@options)
      end

      it "uses the right order number" do
        numbah = Order.next_order_number
        Order.prefill!(@options).number.should == numbah
      end

    end



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
      it "return the sum of the column value of all orders" do
        Order.stub(:sum).with(:value).and_return(50)
        Order.revenue.should == 50
      end
    end

    describe ".current" do
      it "returns the number of orders with valid token / that have been postfilled" do
      end
    end

  end
end
