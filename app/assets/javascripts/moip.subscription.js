MoipSubscription = {
  
  customer: null,
  billing: null,
  // Moip Token for the API
  moipToken: $('meta[property="moip:token"]').attr('content'),


  /**
   * Function to construct a new user with billing info and address
   * Takes a customer Object as argument
   *
   */
  buildCustomer: function(customer) {
   
    this.billing  = customer.subscription
    this.customer = customer.user
    var customer = this.customer;


    // We receive dates in the format 00/00/0000
    // So we split the '/' to separate day, month and year
    customer.birthday  = customer.birthday.split('/');

    // As were receiving phones in the format (00) 00000000?0 (this last 0 is optional)
    // We have to split spaces and the '()' chars
    // I've used the filter function to remove empty strings from the resultant array
    customer.phone     = customer.phone.split(/\(|\)|\s/).filter(function(e){return e});

    var params = {
      code:             new Date().getTime(),
      email:            customer.email,
      fullname:         customer.name,
      cpf:              customer.cpf,
      birthdate_day:    customer.birthday[0],
      birthdate_month:  customer.birthday[1],
      birthdate_year:   customer.birthday[2],
      phone_area_code:  customer.phone[0],
      phone_number:     customer.phone[1],
      billing_info:     this.buildBillingInfo(this.billing),
      address:          this.buildAddress(customer)
    };

    return new Customer(params);
  },

  /**
   * Function to build the customer address in a fashion object
   * Takes a customer Object as argument
   */

  buildAddress: function(customer) {

    // As we are receiving zip code in the format 00000-000
    // We have to split the '-' and join the numbers

    customer.zipcode  = customer.zipcode.split(/\-/).join('');
    var params = {
      street:       customer.address_street,
      number:       customer.address_number,
      complement:   customer.address_extra,
      district:     customer.address_district,
      zipcode:      customer.zipcode,
      city:         customer.city,
      state:        customer.state,
      country:      customer.country
    };

    return new Address(params);

  },

  /**
   * Function to build the Billing info
   * Takes a card from customer.card argument
   *
   */
  buildBillingInfo: function(billing){
  
    var card = billing;
    var params = {
      fullname:           card.fullname,
      credit_card_number: card.card_number,
      expiration_month:   card['expiration_date(2i)'],
      expiration_year:    card['expiration_date(1i)'],
    }

    return new BillingInfo(params);
    
  },
  
  /** 
   * Function to create new subscription
   * arguments: Object customer
   *            String plan_code
   */
  createCustomerSubscription: function(customer, plan_code) {
    var customer  = this.buildCustomer(customer);
    var moip      = new MoipAssinaturas(this.moipToken);
  
    console.log(customer);
    // Creating a subscription for a new user the new user
    moip.subscribe(
      new Subscription()
        .with_code(new Date().getTime())
        .with_new_customer(customer)
        .with_plan_code(plan_code)
    
    // The return function of the new subscribing action    
    ).callback(function(response){

      // Oh-oh, something went wrong
      if (response.has_errors()) {
        var errors = $('#card_error').fadeIn();
        for ( i = 0; i < response.errors.length(); i++) {
          var error = response.errors[i].description;
          errors.append(erro);
        }
      } 
      // If no errors were found
      else {
        this.showSuccessfulSubscriptionMessage();
      }
    });

  },

  showSuccessfulSubscriptionMessage: function(){
    alert('Assinatura foi criada!');
  }

};
