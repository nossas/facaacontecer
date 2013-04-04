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
  cardButton: $('button.card_submit'),

  
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
      'button.card_submit click'      : 'subscribeToPlan',
      '.values li click'              : 'chooseValue',
      'a#faq click'                   : 'openFaq',      
      // External references
      'a.external click'              : 'openPopUp',

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
    $('select').select2({
      width: "20%",
    });


    //this.initializeSocialPlugin("//connect.facebook.net/en_US/all.js#xfbml=1", 'facebok-jssdk');
    //this.initializeSocialPlugin("//platform.twitter.com/widgets.js", 'twitter-wjs');
    //this.initializeSocialPlugin("//apis.google.com/js/plusone.js", 'g-plusone');
    this.initializeMouseflow();

  },


  openFaq: function(event, target){
    event.preventDefault();
    $(event.target).colorbox({ iframe: true, width:"80%", height:"80%"})
  },

  openPopUp: function(event,target) {
    event.preventDefault();
    var obj = $(event.target);
    var url = null;

    url = obj.attr('href');
    if (url == undefined) {
      url = obj.parent('a').attr('href');
    }

    window.open(url, '', 'width=600,height=300');

  },

  // Function to change the hidden select named value
  // Everytime the user clicks, he trigger this function
  chooseValue: function(evt, target) {
    var el = $(evt.target);
    $('ol.values li').removeClass('selected');
    el.addClass('selected');

    
    if (el.data('value') == '0') {
      $('#plan').fadeIn()
    } else {
      $('select#subscription_plan').val(el.data('value'));
    }
    $('select#subscription_plan').select2();
  },



  //TODO: refactor this
  // Basically this function validates every single field
  // from the User Form. Mostly because parsley doesn't trigger
  // in parts.
  validateSiblingInput: function(event, target) {
    event.preventDefault();

    if (target.hasClass('step_one')){
      var classes = ['input.email', 'input.name', 'input.cpf', 'input.date', 'input.phone'];
    } else if (target.hasClass('step_two')) {
      var classes = ['input.addr_city', 'input.cep', 'input.addr_street', 'input.addr_extra', 'input.addr_dist', 'input.addr_number'];
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
    
  // When the user clicks on SUBMIT, we prevent
  // and create the subscription using the moip.subscription.js
  subscribeToPlan: function(event, target) {
    // We'll not submit the known way
    event.preventDefault();

    // Ugly name, I know
    // I prefer 'subscriber'
    var billing_info = this.cardForm.toObject(this.toObjectOptions)[0];
    var customer     = $.fn.extend(this.subscriber, billing_info);
    
    this.plan = this.planField.val();

    // Show the loading
    this.cardButton.addClass('loading');


    // Creating the subscription
    MoipSubscription.createCustomerSubscription(
      customer, this.plan, this.cardForm.data('token'));
  },
   
  // Saving the subscription
  // This function is triggered inside MoiSubscription object
  // and it just submit the form without some useless fields
  // like credit card number (we don't save this)
  // and others.
  saveSubscription: function(code, value){
    $('#subscription_code', this.cardForm).val(code);
    $('#subscription_value', this.cardForm).val(value);
    $('.detach', this.cardForm).detach();
    $('.hide', this.cardForm).hide();
    $('#moip-indicator').fadeIn();
    var self = this;

    // A small timeout to prevent multiple forms being submited 
    // at the same time.
    setTimeout(function(){
      self.cardForm.submit();
    }, 5000);
  },

  // Show a loading gif when needed
  startLoader: function(event){
    this.button.addClass('loading');
  },

  // Something went wrong
  // When the user form fails to be submited
  // this function show all errors and send the
  // user back to the first screen.
  // TODO: make a more inteligent JS, that
  // knows on which screen the user missed.
  userDataNotSent: function(evt, target, data) {
    this.button.removeClass('loading');
    $('fieldset.two').fadeOut(0);
    $('fieldset.one').fadeIn();
    $('ol.steps li span').removeClass('selected');
    $('li.step1 span:first-child').addClass('selected');
    var errors = JSON.parse(data.responseText).errors;
    for (error in errors) {
      $('.subscription .errors').empty().append(error.toUpperCase() + " " + errors[error] + "<br/>");
    }
    $('.subscription .errors').fadeIn(); 
    setTimeout(function(){ $('.subscription .errors').fadeOut() }, 5000)
  },

  // User already sent data? OK! Let's show the billing form
  // After submiting and saving the user, we can now show
  // the Subscription form (and change attributes to match our
  // desires
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
    if (data == undefined || data.logradouro == undefined) return false;


    // If yes, we did find CEP info, fill in the form
    $('#user_address_street').val(data.tp_logradouro + ' ' + data.logradouro);
    $('#user_address_district').val(data.bairro);
    $('#user_city').val(data.cidade);
    $('#user_state').val(data.uf.toUpperCase());
    $('select#user_state').select2();
    
  },

  // Make a request to a SSL api that returns CEP info
  getZipcodeInfo: function(){
    this.loader.fadeIn();
    var self = this;
    $.getJSON('//brazilapi.herokuapp.com/api?cep=' + self.cepField.val(), function(response){
      self.populateAddressFields(response[0]);
    })
  },

  initializeSocialPlugin: function(src, sdk){
    (function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) return;
      js = d.createElement(s); js.id = id;
      js.src = src ;
      js.async = true;
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', sdk));
  },

  initializeMouseflow: function(){
    (function() {
       var mf = document.createElement("script"); mf.type = "text/javascript"; mf.async = true;
       mf.src = "//cdn.mouseflow.com/projects/7293d4b6-4b7b-4ff2-b026-f5329abe2674.js";
       document.getElementsByTagName("head")[0].appendChild(mf);
    })();
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
