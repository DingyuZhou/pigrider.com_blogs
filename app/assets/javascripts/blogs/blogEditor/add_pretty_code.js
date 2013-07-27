var g_oTextareaOperator=TextareaOperation.createNew();
var g_BlogContentTextareaID="blog_content";


addEvent(document.getElementById("buttonAddPrettyCode"), "click", function(event) {
  var sCodeTag=gasAllSHJSCode[document.getElementById("selectPrettyCodeType").selectedIndex];
  var oTextarea=document.getElementById(g_BlogContentTextareaID);
  var oSelect=g_oTextareaOperator.selectRange(g_BlogContentTextareaID);
  oTextarea.value=oTextarea.value.substring(0,oSelect.iSelectStart)+sCodeTag+oTextarea.value.substring(oSelect.iSelectEnd);
});