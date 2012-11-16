(function($){
  var $dashboardLeft = $('.dashboard-matches .dashboard-matches-own-klus');
  var $dashboardRight = $('.dashboard-matches .dashboard-matches-own-klus + .tab-content');
  if ($dashboardLeft.length > 0) {
    if ($dashboardLeft.height() > $dashboardRight.height()) {
      $dashboardRight.height($dashboardLeft.height());
    }
  }
})(jQuery);