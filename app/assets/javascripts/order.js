Selfstarter = window.Selfstarter =  {

  
  step1:      $('.step_1'),
  step2:      $('.step_2'),
  step3:      $('.step_3'),
  value:      null,
  type:       'creditcard',
  cepField:   $('#user_address_cep'),
  valueField: $('#order_value'),
  button:     $('.button'),
  form:       $('#user_form'), 
  ccard_form: $('#credit_form'),
  email:      $('#user_email'),
  links:      $('ol.values li a'),
  messages:   {
    required:   "Este campo é obrigatório",
    email:      "Por favor, insira um e-mail válido",
    date:       "Por favor, insira uma data no formato 99/99/9999",
    creditcard: "Por favor, insira um número de cartão de crédito válido"
  },
  form_options: { mode: 'all', rails: true, skipEmpty: false },

  initialize: function() {

    this.bindEvents({
      'ol.values li a click'          : 'showPaymentOptions',
      'ol.payment_options li a click' : 'showForm',
      'button#checkout click'         : 'finalizeCheckout',
      'input.cep blur'                : 'getAddressCepInformation',
    });

    
    // Set up error messages 
    $.validator.messages = this.messages;

    // Setup order_form validation
    this.form.validate( { onkeyup: true } );
    this.ccard_form.validate( { onkeyup: true } );

    // Initialize Masks
    this.initializeMasks();

  },

  initializeMasks: function(){
    $('.cpf').mask('999.999.999-99');
    $('.date').mask('99/99/9999');
    $('.cep').mask('99999-999');
    $('.phone').mask('(99) 99999999?9');
    $('.money').maskMoney();

  },


  finalizeCheckout: function() {
    if (this.form.valid()) {
      if (this.type == 'boleto') {
        // Start boleto payment
        this.doPaymentWithBoleto();

      } else if (this.type == 'credicard' ) {
        if ( this.ccard_form.valid() ) {

          // Start credit card payment
          this.doPaymentWithCreditCard();
        }
      }
    }
  },


  
  doPaymentWithBoleto: function() {
    this.button.append("Aguarde...");
    var form    = this.form.toObject(this.form_options);
    var result  = this.postOrderForm(form);
    console.log(result);

  },

  doPaymentWithCreditCard: function() {
     
  },


  postOrderForm: function(data) {

    $.ajax({
      url: this.form.attr('action'),
      type: "POST",
      dataType: "json",
      async: "false",
      data: data,
      success: function(data) {
        return data;
      },
      error: function(data) {
        return false;
      }

    });
  },


  getAddressCepInformation: function(){
    var self = this;

    $.ajax({
      url: "//brazilapi.herokuapp.com/api",
      type: "GET",
      dataType: 'json',
      data: { cep: self.cepField.val() },
      success: function(response){
        console.log(response) 
        self.populateAddressFields(response.body);
      },
    
    })
  },

  showForm: function(event,target) {
    target.parents('ol').find('a').removeClass('selected');
    target.addClass('selected');
    this.step2.addClass('grayscale');
    this.step3.fadeIn();
    this.button.fadeIn();
    if (target.data('type') == 'creditcard') {
      this.ccard_form.fadeIn(100) 
      this.type = 'creditcard';
    } else {
      this.ccard_form.fadeOut(10);
      this.type = 'boleto';
    }
      
  },

  showPaymentOptions: function(event, target){
    this.links.removeClass('selected');
    target.addClass('selected');
    this.valueField.val(target.data('value'));
    this.step1.addClass('grayscale');
    this.step2.fadeIn(); 
  },


  // Binding multiple events in an Object hash, avoiding repetition
  // Syntax:
  //
  // Selfstarter.bindEvents({
  //  'div.example mouseover' : 'showSomeContent'
  // });
  //
  // showSomeContent: function() { alert("I'm calling a function!"); }
  //
  bindEvents: function(events) {
    for(evt in events) {

      (function(evt) {
        var options     = evt.split(' ');
        var bindEvent   = options.pop();
        var target      = $(options.join(' '));
        var fn          = Selfstarter[events[evt]];
        target.on(bindEvent, function(event) { fn.apply(Selfstarter,[event, jQuery(event.target)]) }) 
      })(evt);
    }

  },

};


(Selfstarter.initialize)();
