facaAcontecerApp.controller('SubscriptionCtrl', function($scope, $http){
  
  $scope.$watch('zipcode', function(value){
    $http.get("https://brazilapi.herokuapp.com/api?cep=" + value).
      success(populateAddressFields).
        error(showZipcodeNotFoundMessage);

  
  });



  function populateAddressFields(response, status) {
    console.log(response[0]);
    if (!response[0].cep.valid) { 
        showZipcodeNotFoundMessage();
        return false;
    }

    if (response[0].cep.data == undefined) {
        showZipcodeNotFoundMessage();
        return false;
    }

    if (response[0].cep.data == "" || response[0].cep.data.tp_logradouro == "") {
        showZipcodeNotFoundMessage();
        return false;
    }

    var info = response[0].cep.data;
    $scope.cepmessage       = ''; 
    $scope.address_street   = info.tp_logradouro + ' ' + info.logradouro;
    $scope.address_extra    = '';
    $scope.address_number   = '';
    $scope.address_district = info.bairro;
    $scope.city             = info.cidade;
    $scope.state            = info.uf.toUpperCase();
    
  };

  function showZipcodeNotFoundMessage(data) {
    $scope.cepmessage = '';
  };

});
