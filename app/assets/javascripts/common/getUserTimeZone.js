(function() {
  // check if there is cookie "userTimeZone"
  var iBeginPosition = document.cookie.indexOf(";userTimeZone=");
  if (iBeginPosition == -1) {
    iBeginPosition = document.cookie.indexOf("userTimeZone=");
    if (iBeginPosition != 0) {
      iBeginPosition = -1;
    }
  }
  
  if (iBeginPosition == -1) {
    var tTime=new Date();
    var nTimeZoneOffset=-tTime.getTimezoneOffset()/60;
    document.cookie="userTimeZone="+nTimeZoneOffset;
    window.location.reload();
  }
})();