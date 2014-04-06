// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require meurio_ui
//= require jquery.inputmask
//= require jquery.inputmask.extensions
//= require jquery.inputmask.date.extensions

//= require angular
//= require angular-resource
//= require store
//= require moip/moip.subscription
//= require facaacontecerApp
//= require_tree ./angular
//


Apoie = {};

Apoie = { 
  

  initialize: function(){
    Apoie.renderInputMasks();
    Apoie.toggleSubscriptionValues();
    Apoie.togglePaymentOptions();
    Apoie.setDefaultValues();
    Apoie.watchPaymentPlan();
  },

  animationPulseClass: 'animated pulse icon-checkmark selected',
  
  // Start all input masks;
  renderInputMasks: function() {
    $('.expiration-mask').inputmask('mm/yyyy',{ "clearIncomplete": true });
    $('.date-mask').inputmask('99/99/9999', { "clearIncomplete": true });
    $('.zipcode-mask').inputmask('99.999-999', { "clearIncomplete": true });
    $('.cpf-mask').inputmask('999.999.999-99', { "clearIncomplete": true });
    $('.phone-mask').inputmask('(99) 99999999[9]', { "clearIncomplete": true });
    $('.creditcard-mask').inputmask('999999999999999[9]', { "clearIncomplete": true });


  },


  watchPaymentPlan: function(){
    var tab = $('dl.tabs > dd.active');
    var debit = $('.subscription-payment-options input[value="debit"]');
    var slip = $('.subscription-payment-options input[value="slip"]');
    var card = $('.subscription-payment-options input[value="creditcard"]');
    if (tab.hasClass('monthly-tab')){
      slip.parent().addClass('disabled');
      debit.parent().addClass('disabled');

      slip.addClass('disabled').attr('disabled', 'disabled');
      debit.addClass('disabled').attr('disabled', 'disabled');

      card.trigger('click');
    } else {
      slip.parent().removeClass('disabled');
      debit.parent().removeClass('disabled');
      slip.removeClass('disabled').removeAttr('disabled');
      debit.removeClass('disabled').removeAttr('disabled');
    }
  },


  //  Toggle subscription values when the user clicks 
  //  And set the interval for the respective PLAN
  toggleSubscriptionValues: function(){
    $('.subscription-values input').on('click', function(){ 

      var id = $(this).parents('.content').attr('id');
      var interval = $('#user_subscriptions_attributes_0_plan');

      $('.subscription-values label').removeClass(Apoie.animationPulseClass);

      $(this).parent('label').addClass(Apoie.animationPulseClass);
      interval.val(id);


      Apoie.watchPaymentPlan();
    });


  },

  // When Someone clicks on any payment option, show the value
  togglePaymentOptions: function() {
    $('.subscription-payment-options input:not(:disabled)').on('click', function(){
      $('.subscription-payment-options label').removeClass(Apoie.animationPulseClass);
      $(this).parent('label').addClass(Apoie.animationPulseClass).removeClass('icon-checkmark');
      
      var debit = $('.debit');
      var card = $('.creditcard');

      $('.subscription-payment-fields').hide();

      if ($(this).val() == 'creditcard') {
        card.fadeIn();
      }
      else if ($(this).val() == 'debit') {
        debit.fadeIn();
      }

      else {}
      

    
    });

  },

  // Set the default value to the previous SENT SUBSCRIPTION VALUE 
  // Set the default payment to the previous SENT SUBSCRIPTION PAYMENT OPTION
  // See users/_form
  setDefaultValues: function(){
    if (window.$value != "0") {
      $('#' + window.$plan +' .subscription-values input[value="'+window.$value+'"]').trigger('click');
      $('.' + window.$plan + '-tab a').click();
    }
    if (window.$payment != "" ) {
      var input = $('.subscription-payment-options input[value="'+window.$payment+'"]');
      input.prop('checked', true);
      input.trigger('click');
    }

  },



};





$(function(){ 
  $(document).foundation(); 
  Apoie.initialize();
});
