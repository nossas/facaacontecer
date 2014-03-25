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
//= require skrollr
//= require skrollr.ie
//= require jquery.inputmask

//= require angular
//= require angular-resource
//= require facaacontecerApp
//= require_tree ./angular
//

var parallax = skrollr.init();

Apoie = {};

Apoie = { 
  

  initialize: function(){
    Apoie.renderInputMasks();
    Apoie.toggleSubscriptionValues();
    Apoie.togglePaymentOptions();
   // Apoie.setDefaultValues();
  },

  animationPulseClass: 'animated pulse icon-checkmark selected',
  
  // Start all input masks;
  renderInputMasks: function() {
    $('.expiration-mask').inputmask('99/9999',{ "clearIncomplete": true });
    $('.date-mask').inputmask('99/99/9999', { "clearIncomplete": true });
    $('.zipcode-mask').inputmask('99.999-999', { "clearIncomplete": true });
    $('.cpf-mask').inputmask('999.999.999-99', { "clearIncomplete": true });
    $('.phone-mask').inputmask('(99) 9999[9]-9999', { "clearIncomplete": true });
    $('.creditcard-mask').inputmask('9999-9999-9999-9999', { "clearIncomplete": true });


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
    });


  },

  // When Someone clicks on any payment option, show the value
  togglePaymentOptions: function() {
    $('.subscription-payment-options input').on('click', function(){
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

  // Set the default value to the MONTHLY R$ 17
  // Set the default payment option to CREDIT CARD
  setDefaultValues: function(){
    $('.subscription-values input[value="17"]').trigger('click');
    $('.subscription-payment-options input[value="creditcard"]').trigger('click');

  },



};



Apoie.initialize();

$(function(){ $(document).foundation(); });
