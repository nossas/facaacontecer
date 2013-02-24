Selfstarter = window.Selfstarter =  {


  // Window steps for the user
  step1:      $('.step_1'),
  step2:      $('.step_2'),
  step3:      $('.step_3'),

  // The Subscriber
  subscriber: null, 

  // The value selected by the user
  plan:      null,
 
  // Forms
  userForm: $('#user_form'),
  cardForm: $('#subscription_form'),

  // Form fields 
  cepField:   $('#user_zipcode'),
  planField:  $('#subscription_plan'),
  button:     $('input.submit'),
  email:      $('#user_email'),


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
  toObjectOptions: { mode: 'all', rails: true, skipEmpty: false },

  // Loader
  loader: $('img.loader'),


  // Messages
  successMessage: $('span.success'),
  submitTipMessage: $('.next_step_tip'),

  // Initializing
  initialize: function() {
    

    this.bindEvents({
      'ol.values li a click'          : 'showForm',
      'input.cep blur'                : 'getZipcodeInfo',
      '#user_form ajax:beforeSend'    : 'startLoader',
      '#user_form ajax:success'       : 'userDataSent',
      '#subscription_form submit'     : 'subscribeToPlan'

    });

    
    // Initialize Masks
    this.initializeMasks();
    this.disableCreditFormFields();

  },

  initializeMasks: function(){
    $('.cpf').mask('999.999.999-99');
    $('.date').mask('99/99/9999');
    $('.cep').mask('99999-999');
    $('.phone').mask('(99) 99999999?9');
    $('.money').maskMoney();

  },

  subscribeToPlan: function(event, target) {
    // We'll not submit the known way
    event.preventDefault();

    // Ugly name, I know
    // I prefer 'subscriber'
    var billing_info = this.cardForm.toObject(this.toObjectOptions)[0];
    var customer     = this.mergeObjects(this.subscriber, billing_info);

    MoipSubscription.createCustomerSubscription(customer, this.plan);
  },
   

  // Show a loading gif when needed
  startLoader: function(event){
    this.button.addClass('loading');
  },


  // User already sent data? OK! Let's show the billing form
  userDataSent: function(){
    this.subscriber = this.userForm.toObject(this.toObjectOptions)[0];
  userDataSent: function(evt, target, data){

    this.cardForm.attr('action', data.subscription_url);
    this.subscriber = this.userForm.toObject(this.toObjectOptions)[0];
    
    var self        = this;
    
    // We are making things less faster for UX purposes
    setTimeout(function(){
      self.button.detach();
      self.submitTipMessage.detach();
      self.successMessage.fadeIn();
      self.step2.fadeOut('fast').detach();
      self.step3.fadeIn();
      self.step3.children('#plan').show();
      self.enableCreditFormFields();
    }, 1000);
  },


  // A function to merge objects (obj1 + obj2 = obj3)
  mergeObjects: function(obj1, obj2) {
    var obj3 = {};
    for (var attrname in obj1) { obj3[attrname] = obj1[attrname]; }
    for (var attrname in obj2) { obj3[attrname] = obj2[attrname]; }
    return obj3;
   },


   // Prevent the user to do things before we can build an user
  disableCreditFormFields: function(){
   $('input, select', this.cardForm).attr('disabled', 'disabled'); 
  },

  // Enable if the user form is ok
  enableCreditFormFields: function(){
   $('input, select', this.cardForm).removeAttr('disabled'); 
  },

 

  // After getting the CEP, populate the addresses fields
  populateAddressFields: function(data) {
    this.loader.fadeOut();
    


    var data = data.cep.data;

    // Return nothing if the query didn't find anything
    if (data == undefined) return false;


    // If yes, we did find CEP info, fill in the form
    $('#user_address_street').val(data.tp_logradouro + ' ' + data.logradouro);
    $('#user_address_district').val(data.bairro);
    $('#user_city').val(data.cidade);
    $('#user_state').val(data.uf.toUpperCase());
    
  },

  // Make a request to a SSL api that return CEP info
  getZipcodeInfo: function(){
    this.loader.fadeIn();
    var self = this;
    $.getJSON('//brazilapi.herokuapp.com/api?cep=' + self.cepField.val(), function(response){
      self.populateAddressFields(response[0]);
    })
  },


  // Show the user Form
  showForm: function(event,target) {
    target.parent().siblings('li').removeClass('selected');
    target.parent().addClass('selected');
    this.step2.fadeIn();
    this.planField.val(target.data('plan'));
    this.plan = target.data('plan');
      
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
        target.on(bindEvent, function(event, data) { fn.apply(Selfstarter,[event, jQuery(event.target), data]) }) 
      })(evt);
    }

  },

};


(Selfstarter.initialize)();
