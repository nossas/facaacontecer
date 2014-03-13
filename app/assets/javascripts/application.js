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

//= require angular
//= require angular-resource
//= require angular-animate
//= require facaacontecerApp
//= require_tree ./angular
//
$(function(){ $(document).foundation(); });


Apoie = {};

Apoie = { 
  

  initialize: function(){
    Apoie.renderInputMasks();
    Apoie.toggleSubscriptionValues();
    Apoie.togglePaymentOptions();
  },

  animationPulseClass: 'animated pulse icon-checkmark selected',

  renderInputMasks: function() {
    $('.expiration-mask').inputmask('99/9999');
    $('.date-mask').inputmask('99/99/9999');
    $('.zipcode-mask').inputmask('99.999-999');
    $('.cpf-mask').inputmask('999.999.999-99');
    $('.phone-mask').inputmask('(99) 9999[9]-9999');
    $('.creditcard-mask').inputmask('9999-9999-9999-9999');


  },


  toggleSubscriptionValues: function(){
    $('.subscription-values input').on('click', function(){ 

      var id = $(this).parents('.content').attr('id');
      var parent = $('.subscription-interval input#subscription_interval_'+id);

      $('.subscription-values label').removeClass(Apoie.animationPulseClass);

      $(this).parent('label').addClass(Apoie.animationPulseClass);
      parent.trigger('click');
    });


  },


  togglePaymentOptions: function() {
    $('.subscription-payment-options input').on('click', function(){
      $('.subscription-payment-options label').removeClass(Apoie.animationPulseClass);
      $(this).parent('label').addClass(Apoie.animationPulseClass).removeClass('icon-checkmark');

      var card = $('.creditcard');
      if ($(this).val() == 'creditcard') {
        card.fadeIn();
      } else { 
        card.hide();
      }
    });

  },



};



Apoie.initialize();

