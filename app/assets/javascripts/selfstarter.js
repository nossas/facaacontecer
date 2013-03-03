Selfstarter = window.Selfstarter =  {


  // Window steps for the user
  step1:      $('div.step1'),
  step2:      $('div.step2'),
  
  // The Subscriber
  subscriber: null, 


  // The value selected by the user
  plan:      null,
 
  // Forms
  userForm: $('#user_form'),
  cardForm: $('#subscription_form'),

  // Form fields 
  inputs:     $('form input'),
  cepField:   $('#user_zipcode'),
  planField:  $('#subscription_plan'),

  // Buttons
  button:     $('button.step_two'),
  cardButton: $('input.card_submit'),

  
  // The values that the user selects 
  links:      $('ol.values li a'),


  // Mapping the form to send to the server (just client data, not credit card)
  toObjectOptions: { mode: 'all', rails: true, skipEmpty: false },

  // Loader
  loader: $('img.loader'),


  // Messages
  successMessage:   $('span.success'),
  submitTipMessage: $('.next_step_tip'),

  // Initializing
  initialize: function() {
    

    this.bindEvents({
      'input.cep blur'                : 'getZipcodeInfo',
      '#user_form ajax:beforeSend'    : 'startLoader',
      '#user_form ajax:success'       : 'userDataSent',
      '#user_form ajax:error'         : 'userDataNotSent',
      'input.card_submit click'       : 'subscribeToPlan',
      '.values li click'              : 'chooseValue',


      // Steps validation

      'button.step_one click'  : 'validateSiblingInput',
      'button.step_two click'  : 'validateSiblingInput'

    });

     
    // Initialize Masks
    this.initializeMasks();
    this.disableCreditFormFields();
    this.inputs.placeholder();
  },

  initializeMasks: function(){
    $('.cpf').mask('999.999.999-99');
    $('.date').mask('99/99/9999');
    $('.cep').mask('99999-999');
    $('.phone').mask('(99) 99999999?9');
    $('.money').maskMoney();

  },

  chooseValue: function(evt, target) {
    var el = $(evt.target);
    $('ol.values li').removeClass('selected');
    el.addClass('selected');
    
    if (el.data('value') == '0') {
      $('#plan').fadeIn()
    } else {
      $('select#subscription_plan').val(el.data('value'));
    }

  },

  validateSiblingInput: function(event, target) {
    event.preventDefault();

    if (target.hasClass('step_one')){
      var classes = ['input.email', 'input.name', 'input.cpf', 'input.date', 'input.phone'];
    } else if (target.hasClass('step_two')) {
      var classes = ['input.addr_city', 'input.cep', 'input.addr_state', 'input.addr_street', 'input.addr_extra', 'input.addr_dist', 'input.addr_number'];
    }
    var ok = 0; 

    $.each(classes, function(k, v){
      if ($(v).parsley('validate'))
        ok += 1;
    });


    if (ok == classes.length && target.hasClass('step_one')) {
      $('fieldset.one').fadeOut(0);
      $('fieldset.two').fadeIn();
      $('li.step1 span:first-child').removeClass('selected');
      $('li.step2 span:first-child').addClass('selected');
    } else if (ok == classes.length && target.hasClass('step_two')){
      $('li.step2 span:first-child').removeClass('selected');
      $('li.step3 span:first-child').addClass('selected');
      this.userForm.submit();
    }
    
  },

  subscribeToPlan: function(event, target) {
    // We'll not submit the known way
    event.preventDefault();

    // Ugly name, I know
    // I prefer 'subscriber'
    var billing_info = this.cardForm.toObject(this.toObjectOptions)[0];
    var customer     = this.mergeObjects(this.subscriber, billing_info);
    
    this.plan = this.planField.val();

    // Show the loading
    this.cardButton.addClass('loading');


    // Creating the subscription
    MoipSubscription.createCustomerSubscription(
      customer, this.plan, this.cardForm.data('token'));
  },
   
  // Saving the subscription
  saveSubscription: function(code, value){
    $('#subscription_code', this.cardForm).val(code);
    $('#subscription_value', this.cardForm).val(value);
    $('.wrap', this.cardForm).detach();

    var self = this;
    setTimeout(function(){
      self.cardForm.submit();
    }, 3000);
  },

  // Show a loading gif when needed
  startLoader: function(event){
    this.button.addClass('loading');
  },

  // Something went wrong
  userDataNotSent: function(evt, target, data) {
    this.button.removeClass('loading');
    $('fieldset.two').fadeOut(0);
    $('fieldset.one').fadeIn();
    $('ol.steps li span').removeClass('selected');
    $('li.step1 span:first-child').addClass('selected');
    var errors = JSON.parse(data.responseText).errors;
    for (error in errors) {
      $('.subscription .errors').append(error.toUpperCase() + " " + errors[error] + "<br/>");
    }
    
    setTimeout(function(){ $('.subscription .errors').fadeOut() }, 5000)
  },

  // User already sent data? OK! Let's show the billing form
  userDataSent: function(evt, target, data){

    this.cardForm.attr('action', data.subscription_url);
    this.subscriber = this.userForm.toObject(this.toObjectOptions)[0];
    
    var self        = this;
    
    // We are making things less faster for UX purposes
    setTimeout(function(){
      self.button.detach();
      self.submitTipMessage.detach();
      self.successMessage.fadeIn();
      self.step1.fadeOut('fast').detach();
      self.step2.fadeIn();
      self.step2.children('#plan').show();
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
