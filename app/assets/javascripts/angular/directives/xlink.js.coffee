# http://stackoverflow.com/questions/15895483/angular-ng-href-and-svg-xlink

pairs = [
  { ngAttrName: 'ngXlinkHref', attrName: 'xlink:href' }
#  { ngAttrName: 'ngWidth', attrName: 'width' }
#  { ngAttrName: 'ngHeight', attrName: 'height' }
]

angular.forEach pairs, (pair) ->
  ngAttrName = pair.ngAttrName
  attrName = pair.attrName
  window.sencha.directive ngAttrName, ->
    priority: 99
    link: (scope, element, attrs) ->
      attrs.$observe ngAttrName, (value) ->
        return unless value
        attrs.$set attrName, value
        isIE = navigator.userAgent.indexOf('MSIE') != -1
        element.prop(attrName, value) if isIE
