facaAcontecerApp.controller('SubscriptionCtrl', function($scope, $http){
      
  $scope.zipcode        = window.$zipcode;
  $scope.cepApi         = "https://brazilapi.herokuapp.com/api?cep=";
  if (store.get('card_number')) {
    $scope.card_number = store.get('card_number');
    $scope.card_expire = store.get('card_expire');
    $scope.card_holder = store.get('card_holder');
  };
  

  $scope.$watch('card_number', function(){
    store.set('card_number', $scope.card_number);
  });

  $scope.$watch('card_holder', function(){
    store.set('card_holder', $scope.card_holder);
  });

  $scope.$watch('card_expire', function(){
    store.set('card_expire', $scope.card_expire);
  });

  $scope.getZipcodeData = function() {
    $http.get($scope.cepApi + $scope.zipcode).
    success($scope.populateAddressFields).
      error($scope.showZipcodeNotFoundMessage);
  };

  $scope.isCreditCard = function(){
   if ($scope.payment_option == 'creditcard') {
      return true;
   } else { 
     return false 
   }
  };

  $scope.populateAddressFields = function(response, status) {
    //console.log(response[0]);
    if (!response[0].cep.valid) { 
        $scope.showZipcodeNotFoundMessage();
        return false;
    }

    if (response[0].cep.data == undefined) {
        $scope.showZipcodeNotFoundMessage();
        return false;
    }

    if (response[0].cep.data == "" || response[0].cep.data.tp_logradouro == "") {
        $scope.showZipcodeNotFoundMessage();
        return false;
    }

    var info = response[0].cep.data;
    $scope.address_street   = info.tp_logradouro + ' ' + info.logradouro;
    $scope.address_district = info.bairro;
    $scope.city             = info.cidade;
    $scope.state            = info.uf.toUpperCase();
   
  };

  $scope.showZipcodeNotFoundMessage = function(data) {
    $scope.cepmessage = '';
  };



  $scope.getZipcodeData();
});
