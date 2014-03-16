facaAcontecerApp.directive('ngBlur', function () {
  return function (scope, element, attrs) {
    scope.$watch(attrs.blur, function () {
        element[0].blur();
    });
  };
});
