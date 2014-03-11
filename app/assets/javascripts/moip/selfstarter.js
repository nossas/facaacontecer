Selfstarter = window.Selfstarter =  {


  // Window steps for the user
  step1:      $('div.step1'),
  step2:      $('div.step2'),
  
  // The Subscriber
  subscriber: null, 
  
  // The value selected by the user
  plan:       null,
 
  // Forms
  userForm: $('#user_form'),
  cardForm: $('#subscription_form'),
  boletoForm: $('#boleto_subscription_form'),

  // Form fields 
  inputs:     $('form input'),
  cepField:   $('#user_zipcode'),
  planField:  $('#subscription_plan'),

  // Buttons
  button:     $('button.step_two'),
  cardButton: $('button.card_submit'),
  boletoButton: $('button.boleto_submit'),

  
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
      'button.boleto_submit click'    : 'subscribeToBoleto',
      '.values li click'              : 'chooseValue',
      '.payment_options li click'     : 'choosePaymentOption',
      'a#faq click'                   : 'openFaq',      
      // External references
      'a.external click'              : 'openPopUp',
      'input#user_email blur'         : 'removeTrailingSpaces',

      // Steps validation
      'button.step_one click'  : 'validateSiblingInput',
      'button.step_two click'  : 'validateSiblingInput'
    });

    //Initialize Social
    //this.initializeSocialPlugin("//connect.facebook.net/en_US/all.js#xfbml=1", 'facebok-jssdk');
    //this.initializeSocialPlugin("//platform.twitter.com/widgets.js", 'twitter-wjs');
    //this.initializeSocialPlugin("//apis.google.com/js/plusone.js", 'g-plusone');
     
    // Initialize Masks
    this.initializeMasks();
    this.disableCreditFormFields();
    this.inputs.placeholder();
    //this.initializeMixPanel();
    //this.initializeMouseflow();
  },
  
  initializeMasks: function(){
    $('.cpf').mask('999.999.999-99');
    $('.date').mask('99/99/9999');
    $('.cep').mask('99999-999');
    $('.phone').mask('(99) 99999999?9');
    this.initializeSelects();
  },

  initializeSelects: function(){
    $('select').select2({
      width: "20%",
    });
  },


  openFaq: function(event, target){
    event.preventDefault();
    $(event.target).colorbox({ iframe: true, width:"80%", height:"80%"})
  },

  removeTrailingSpaces: function(event, target){
    var obj = $(event.target);
    obj.val($.trim(  obj.val().toLowerCase()  ));

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


  changeSelectedElement: function(element) {
    element.parents('ol').children('li').removeClass('selected');
    element.addClass('selected');
  },

  // Function to switch between boleto and credit card payment options
  // Every time the user clicks, trigger this function
  choosePaymentOption: function(evt, target) {
    var el = $(evt.target);
    this.changeSelectedElement(el);
    if (el.hasClass('bankslip')) {
      this.cardForm.fadeOut(0);
      this.boletoForm.fadeIn(100);
    } else {
      this.boletoForm.fadeOut(0);
      this.cardForm.fadeIn(100);
    }
  
  },



  // Function to change the hidden select named value
  // Everytime the user clicks, he trigger this function
  chooseValue: function(evt, target) {
    var el = $(evt.target);
    this.changeSelectedElement(el);

    
    if (el.data('value') == '0') {
      el.parents('fieldset').find('.plans').fadeIn();
    } else {
      el.parents('fieldset').find('select#subscription_plan').val(el.data('value'));
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
      var classes = ['input.email', 'input.first_name', 'input.last_name', 'input.cpf', 'input.date', 'input.phone'];
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


  subscribeToBoleto: function(event, target) {
    var value = $('select#subscription_plan', this.boletoForm).val();
    event.preventDefault();
    this.boletoButton.addClass('loading');
    this.cardForm.detach();
    this.saveSubscription('', value, this.boletoForm );

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
  saveSubscription: function(code, value, form){
    $('#subscription_code', form).val(code);
    $('#subscription_value', form).val(value);
    $('.detach', form).detach();
    $('.hide', form).hide();
    $('.moip-indicator', form).fadeIn();
    var self = this;

    // A small timeout to prevent multiple forms being submited 
    // at the same time.
    setTimeout(function(){
      form.submit();
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
  // desires)
  userDataSent: function(evt, target, data){

    this.cardForm.attr('action', data.subscription_url);
    this.boletoForm.attr('action', data.boleto_subscription_url);
    this.subscriber = this.userForm.toObject(this.toObjectOptions)[0];
    
    var self        = this;
   

    // We are doing tests using optimizely, so
    // we are tracking here which subset of tests
    // the user is exposed to
    //console.log(this.subscriber);
    
/*    mixpanel.identify(this.subscriber.user.email);*/
    //mixpanel.people.set({ 
      //"$email": this.subscriber.user.email, 
      //"$name": this.subscriber.user.name, 
    //})
    /*mixpanel.track('Registered as user');*/

    // We are making things less faster for UX 
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
   $('input, select', this.boletoForm).attr('disabled', 'disabled'); 
  },

  // Enable if the user form is ok
  enableCreditFormFields: function(){
   $('input, select', this.cardForm).removeAttr('disabled'); 
   $('input, select', this.boletoForm).removeAttr('disabled'); 
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

  initializeMixPanel: function(){
   (function(e,b){
     if(!b.__SV){
       var a,f,i,g;window.mixpanel=b;a=e.createElement("script");
       a.type="text/javascript";a.async=!0;
       a.src=("https:"===e.location.protocol?"https:":"http:")+'//cdn.mxpnl.com/libs/mixpanel-2.2.min.js';
       f=e.getElementsByTagName("script")[0];f.parentNode.insertBefore(a,f);
       b._i=[];b.init=function(a,e,d){function f(b,h){var a=h.split(".");2==a.length&&(b=b[a[0]],h=a[1]);
         b[h]=function(){b.push([h].concat(Array.prototype.slice.call(arguments,0)))}}var c=b;"undefined"!==
typeof d?c=b[d]=[]:d="mixpanel";c.people=c.people||[];c.toString=function(b){var a="mixpanel";"mixpanel"!==d&&(a+="."+d);b||(a+=" (stub)");return a};
         c.people.toString=function(){return c.toString(1)+".people (stub)"};
         i="disable track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config people.set people.set_once people.increment people.append people.track_charge people.clear_charges people.delete_user".split(" ");for(g=0;g<i.length;g++)f(c,i[g]);
b._i.push([a,e,d])};b.__SV=1.2}})
      (document,window.mixpanel||[]);mixpanel.init("d74342cd2575ab56d273c18e45e74bd0");
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
        $(document).on(bindEvent, target.selector, function(event, data) { fn.apply(Selfstarter,[event, jQuery(event.target), data]) }) 
      })(evt);
    }

  },

};


(Selfstarter.initialize)();
