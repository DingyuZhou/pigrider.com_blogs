(function() {
  var tTime=new Date();
  var nTimeZoneOffset=-tTime.getTimezoneOffset()/60;
  document.cookie="userTimeZone="+nTimeZoneOffset;
})();