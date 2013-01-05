Selfstarter = window.Selfstarter =  {

  firstTime:  true,
  value:      null,
  form:       $('#order_form'), 
  valueField: $('#order_form').find('input[name="order[value]"]'),
  email:      $('#order_email'),
  button:     $('#self_button'),
  step1:      $('.step_1'),
  step2:      $('.step_2'),
  step3:      $('.step_3'),
  links:      $('ol.values li a'),

  initialize: function() {

    this.bindEvents({
      '#order_email textchange'       : 'validateEmail',
      '#order_email hasText'          : 'validateEmail',
      '#order_email change'           : 'unsetFirstTime',
      'ol.values li a click'          : 'showPaymentOptions',
      'ol.payment_options li a click' : 'showForm'
    });

    this.initializeMasks();
    this.validateEmail();
  },

  initializeMasks: function(){
    $('.cpf').mask('999.999.999-99');
    $('.date').mask('99/99/9999');
    $('.cep').mask('99999-999');
    $('.phone').mask('(99) 99999999?9');
    $('.money').maskMoney();

  },

  unsetFirstTime: function(){
    this.firstTime = false
  },

  showForm: function(event,target) {
    target.parents('ol').find('a').removeClass('selected');
    target.addClass('selected');
    this.step2.addClass('grayscale');
    this.step3.fadeIn();

  },

  showPaymentOptions: function(event, target){
    this.links.removeClass('selected');
    target.addClass('selected');
    this.valueField.val(target.data('value'));
    this.step1.addClass('grayscale');
    this.step2.fadeIn(); 
  },


  isValidEmail: function(email) {
    return /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/.test(email)
  },

  validateEmail: function(){

    if ( this.isValidEmail(this.email.val()) ) {
      this.email.removeClass('highlight');
      this.button.removeClass('disabled');
    }
    else {
      if ( this.firstTime ) {
        this.email.addClass('highlight');
      }
      if ( !this.button.hasClass('disabled') ) {
        this.button.addClass("disabled");
      }
    }
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
