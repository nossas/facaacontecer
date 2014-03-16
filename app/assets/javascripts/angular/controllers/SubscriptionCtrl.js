facaAcontecerApp.controller('SubscriptionCtrl', function($scope, $http){
      
  $scope.subscriber = new Object();
  $scope.subscription = new Object();

  $scope.subscribersApi = "/subscribers/";
  $scope.cepApi         = "https://brazilapi.herokuapp.com/api?cep=";

  
  $scope.sendSubscriptionForm = function() {
    $http.post('/subscribers/', $scope.subcriber).success().error();
  };

  $scope.getZipcodeData = function() {
    alert('hi');
    $http.get($scope.cepApi + value).
    success($scope.populateAddressFields).
      error($scope.showZipcodeNotFoundMessage);
  };


  $scope.populateAddressFields = function(response, status) {
    console.log(response[0]);
    if (!response[0].cep.valid) { 
        showZipcodeNotFoundMessage();
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

});
