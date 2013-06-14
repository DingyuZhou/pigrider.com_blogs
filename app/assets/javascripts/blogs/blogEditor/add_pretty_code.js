var g_oTextareaOperator=TextareaOperation.createNew();
var g_BlogContentTextareaID="blog_content";


addEvent(document.getElementById("buttonAddPrettyCode"), "click", function(event) {
  var sCodeTag="";
  switch (document.getElementById("selectPrettyCodeType").selectedIndex) {
  case 0:
    return;
  case 1:      // HTML
    sCodeTag="<pre class='sh_html'>\n</pre>";
    break;
  case 2:      // CSS
    sCodeTag+="<pre class='sh_css'>\n</pre>";
    break;
  case 3:      // JavaScript
    sCodeTag+="<pre class='sh_javascript_dom'>\n</pre>";
    break;
  case 4:      // Ruby on Rails
    sCodeTag+="<pre class='sh_ruby'>\n</pre>";
    break;
  case 5:      // Python
    sCodeTag+="<pre class='sh_python'>\n</pre>";
    break;
  case 6:      // Java
    sCodeTag+="<pre class='sh_java'>\n</pre>";
    break;
  case 7:      // C++
    sCodeTag+="<pre class='sh_cpp'>\n</pre>";
    break;
  case 8:      // SQL
    sCodeTag+="<pre class='sh_sql'>\n</pre>";
    break;
  }
  
  var oTextarea=document.getElementById(g_BlogContentTextareaID);
  var oSelect=g_oTextareaOperator.selectRange(g_BlogContentTextareaID);
  oTextarea.value=oTextarea.value.substring(0,oSelect.iSelectStart)+sCodeTag+oTextarea.value.substring(oSelect.iSelectEnd);
});