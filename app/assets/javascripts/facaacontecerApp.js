facaAcontecerApp = angular.module('facaAcontecerApp', ['ngResource']);


Apoie = {};

Apoie = {


  initialize: function(){
    Apoie.renderInputMasks();
    Apoie.selectedStyleEvent();
    Apoie.watchPaymentPlanClick();
    Apoie.watchPaymentPlan();
    Apoie.watchPaymentOptionChoice();
    Apoie.watchShareButtons();

    $("#user_subscriptions_attributes_0_plan_monthly").click();
  },

  animationPulseClass: 'animated pulse icon-checkmark selected',

  // Start all input masks;
  renderInputMasks: function() {
    var self = Apoie;
    self.defineInputMask('.expiration-mask', 'mm/yyyy');
    self.defineInputMask('.date-mask', '99/99/9999');
    self.defineInputMask('.zipcode-mask', '99.999-999');
    self.defineInputMask('.cpf-mask', '999.999.999-99');
    self.defineInputMask('.phone-mask', '(99) 99999999[9]');
    self.defineInputMask('.creditcard-mask', '999999999999999[9]');


  },

  defineInputMask: function(klass, mask) {
    $(klass).inputmask(mask, { "clearIncomplete": true });
  },


  watchPaymentPlan: function(){

    switch(window.$plan) {
      case "0":
        break;
      default:
        $('input[value="'+ window.$plan +'"]').trigger('click');
        break;
    }

  },

  startPaymentFlux: function(val) {
    var self = Apoie;

    self.showValuesForPlan(val);
    self.setDefaultSubscriptionValue();
    self.showPaymentOptionsForPlan(val);

  },

  watchPaymentOption: function() {
    switch (window.$payment) {
      case "":
        break;
      default:
        $('input[value="' + window.$payment + '"]').trigger('click');

    }
  },


  watchPaymentPlanClick: function() {
    var self = Apoie;
    $('.subscription-plans input').on('click', function(){
      self.startPaymentFlux($(this).val());
      Apoie.watchPaymentOption();

    });

  },


  // Selected style event for radio buttons
  selectedStyleEvent: function(klass){
    var selected = 'input[type="radio"]';
    var self = Apoie;
    $(selected).on('click', function(){

      var obj = $(this);
      $('label.radio').has('input[value="' + obj.val() + '"]').siblings().removeClass(Apoie.animationPulseClass);
      obj.parent('label').addClass(Apoie.animationPulseClass).removeClass('icon-checkmark');

    });
  },

  // When a plan is selected, show children values
  showValuesForPlan: function(plan) {
    var tabs = $('.tabs-content');
    var self = Apoie;
    window.$plan = plan;

    tabs.show();
    tabs.children('.content').hide()

    $('.tabs-content #' + plan).show();
    $('.subscription-choose-option').hide();

    self.toggleDefaultValue('input:eq(1)');
  },


  // Set given value if window.value is present or
  // set a default one if it's not
  setDefaultSubscriptionValue: function(){
    var value = window.$value;
    var self = Apoie;

    switch(parseInt(value)) {
      case 0:
        self.toggleDefaultValue('input:eq(1)');
        break;
      default:
        self.toggleDefaultValue('input[value="'+ value +'"]');
        break;
    }

  },

  // To activate selected event based on input rule
  toggleDefaultValue: function(rule) {
    console.log(rule);
    var input = $('.' + window.$plan + '-values label ' + rule);
    input.trigger('click');
    input.prop('checked', true);
  },



  // When Someone clicks on any payment option, show the value
  showPaymentOptionsForPlan: function(plan) {

    var not_monthly = $('input[value="debit"], input[value="slip"]');

    console.log(plan);
    switch(plan) {
      case "monthly":
        not_monthly.each(function() {
          $(this).parent().addClass('disabled').
            attr('title', 'Esta opção não está disponível no plano Mensal').
            attr('data-tooltip', '');
          $(this).attr('disabled', 'disabled')
          $('input[value="creditcard"]').trigger('click');
        });
        break;
      default:
        not_monthly.each(function() {
          $(this).removeAttr('disabled');
          $(this).parent().removeClass('disabled has-tip').removeAttr('title').removeAttr('data-tooltip');
        });
        break;
    }

    $('.payment-options').show();


  },


  watchPaymentOptionChoice: function() {
    $('.subscription-payment-options input:not(:disabled)').on('click', function(){


      var debit = $('.debit');
      var card = $('.creditcard');

      $('.subscription-payment-fields').hide();

      switch($(this).val()) {
        case 'creditcard':
          card.fadeIn();
          break;
        case 'debit':
          debit.fadeIn();
          break;

      }
    });
  },

  watchShareButtons: function() {
    $("a.share-button").click(function(event){
      var self = $(this);
      window.open(
        self.attr("href"),
        'share-dialog',
        'width=626,height=436'
      );
      return false;
    });
  }
};
