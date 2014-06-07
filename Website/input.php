<textarea id="textArea" style="width: 700px; height:500px">
No menyou found
</textarea>
<script type="text/javascript" src="JS/jquery-1.9.1..js"></script>
	<script type='text/javascript' src='http://code.jquery.com/jquery-1.7.1.js'></script>
	<script type='text/javascript' src='http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js'></script>
<script type="text/javascript" charset="utf-8" src="JS/jquery.leanModal.min.js"></script>
<input type="submit" value="Submit" onclick="return upload()" />

<script type="text/javascript">
    xmlHttp = new XMLHttpRequest();
    var url = "http://menyouapp.com/getMenu.php?ids="+getQueryVariable("business");
    xmlHttp.open( "GET", url, false);
    xmlHttp.send();
    var retVal = xmlHttp.responseText;
	result = JSON.parse(retVal);                                   // parse JSON and check Status
	
	if(result[0].Found == false) {
	  var business = getQueryVariable("business")
      var session = getQueryVariable("sessionid");
      var username= getQueryVariable("username");
	  window.location.href = "http://menyouapp.com/form2js.php?username=" + username + "&name=" + business + "&sessionid=" + session;
	}
	
	//document.getElementById("textArea").value = result.Found;
	
    document.getElementById("textArea").value = retVal;
    
    
    function getQueryVariable(variable)
{
       var query = window.location.search.substring(1);
       var vars = query.split("&");
       for (var i=0;i<vars.length;i++) {
               var pair = vars[i].split("=");
               if(pair[0] == variable){return pair[1];}
       }
       return(false);
}

function upload()
{
var menu = document.getElementById("textArea").value;
var business = getQueryVariable("business")
var session = getQueryVariable("sessionid");
var username= getQueryVariable("username");
    xmlHttp = new XMLHttpRequest();
    var url = "http://menyouapp.com/createMenu.php?username="+username+"&sessionid="+session+"&name="+business+"&data="+menu;
    xmlHttp.open( "GET", url, false);
    xmlHttp.send();
return false;
}

</script>