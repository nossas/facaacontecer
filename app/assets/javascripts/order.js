Selfstarter = window.Selfstarter =  {

  // Moip Token for the API
  moipToken: $('meta[property="moip:token"]').attr('content'),

  // Initializing moip signatures
  moipSubscriber: new MoipAssinaturas(this.moipToken),

  // Window steps for the user
  step1:      $('.step_1'),
  step2:      $('.step_2'),
  step3:      $('.step_3'),

  // The value selected by the user
  value:      null,
 
  // Form fields 
  cepField:   $('#user_address_cep'),
  valueField: $('#order_value'),
  button:     $('.button'),
  form:       $('#user_form'), 
  email:      $('#user_email'),

  // The credit card form
  ccard_form: $('#credit_form'),

  // Links
  links:      $('ol.values li a'),

  // Messages for the jQuery validator
  messages:   {
    required:   "Este campo é obrigatório",
    email:      "Por favor, insira um e-mail válido",
    date:       "Por favor, insira uma data no formato dd/mm/aaaa",
    creditcard: "Por favor, insira um número de cartão de crédito válido"
  },

  // Mapping the form to send to the server (just client data, not credit card)
  form_options: { mode: 'all', rails: true, skipEmpty: false },



  // Initializing
  initialize: function() {
    

    this.bindEvents({
      'ol.values li a click'          : 'showPaymentOptions',
      'ol.payment_options li a click' : 'showForm',
      'button#checkout click'         : 'finalizeCheckout',
      'input.cep blur'                : 'getAddressCepInformation',
    });

    
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

    }
   
  },



  postOrderForm: function(data) {
    $.post(this.form.attr('action'), { data: data }, function(response){}, 'json');
  },


  populateAddressFields: function(data) {
    var data = data.cep.data;
    $('#user_address_street').val(data.tp_logradouro + ' ' + data.logradouro);
    $('#user_address_neighbourhood').val(data.bairro);
    $('#user_address_city').val(data.cidade);
    $('#user_address_state').val(data.uf.toUpperCase());
    
  },

  getAddressCepInformation: function(){
    var self = this;
    $.getJSON('//brazilapi.herokuapp.com/api?cep=' + self.cepField.val(), function(response){
      self.populateAddressFields(response[0]);
    })
  },

  showForm: function(event,target) {
    target.parents('ol').find('a').removeClass('selected');
    target.addClass('selected');
    this.step2.addClass('grayscale');
    this.step3.fadeIn();
    this.button.fadeIn();
    this.ccard_form.fadeIn(100) 
      
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
