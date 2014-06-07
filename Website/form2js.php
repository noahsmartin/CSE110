<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/>
	<title>Create Your Menyou!</title>
	
<style type="text/css">
</style>

<div id="dom-target" style="display: none;">
<?php
    $username = "stepshep"; 
    $password = "menyoucs110"; 
    $host = "users.csss5n4ctp7b.us-east-1.rds.amazonaws.com"; 
    $dbname = "innodb"; 

    // By passing the following $options array to the database connection code we 
    // are telling the MySQL server that we want to communicate with it using UTF-8 
    $options = array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'); 
    
    try 
    { 
        $db = new PDO("mysql:host={$host};dbname={$dbname};charset=utf8", $username, $password, $options); 
    } 
    catch(PDOException $ex) 
    { 
        die("Failed to connect to the database: " . $ex->getMessage());
    }
    
        // This statement configures PDO to throw an exception when it encounters 
    // an error.
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); 
     
    // This statement configures PDO to return database rows from your database using an associative 
    // array. 
    $db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC); 
     
	 $query = "SELECT numberdishes FROM menu WHERE menuid = :name";
        $query_params = array( 
            ':name' => $_GET['name'] 
        ); 
        
        try 
        { 
            // Execute the query 
            $stmt = $db->prepare($query); 
            $result = $stmt->execute($query_params);
            $row = $stmt->fetch();
	    }
		catch(PDOException $ex) 
        { 
            // Note: On a production website, you should not output $ex->getMessage(). 
            // It may provide an attacker with helpful information about your code.  
            die("Failed to run query: " . $ex->getMessage()); 
        }
		
		if($row) {
		$output = $row[numberdishes]; //Again, do some operation, get the output.
        echo htmlspecialchars($output);
		}
		else {
		$output = 0;
		echo htmlspecialchars($output);
		}
?>

</div>

<script type="text/javascript">
    var div = document.getElementById("dom-target");
    var dishcounter = div.textContent;
	dishcounter--;
	dishcounter++;
	var catcounter = 1;
	var dishplace = 0;

function addInput(divName){
          dishplace = 0;
          var newdiv = document.createElement('div');
          newdiv.innerHTML = "<dt> <label> <input type='hidden' name='categories[" + (catcounter-1) + "].categoryid' value='<?php echo $_GET['name'] ?>-" + catcounter + "' /></label><label style = 'font size = 16'>Category " + catcounter + " Title <input type='text' name='categories[" + (catcounter-1) + "].title' value='Title' /></label></dt>";
          document.getElementById(divName).appendChild(newdiv);
          catcounter++;
}

function addInput2(divName){
          var newdiv = document.createElement('div');
          newdiv.innerHTML = "<dd><label> <input type='hidden' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].dishid' value ='<?php echo $_GET['name'] ?>-" + dishcounter + "' /></label><label>Dish " + (dishplace + 1) + " Title <input type='text' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].title' value ='Dish title' /></label><label>Price <input type='text' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].price' value ='$10' /></label></dd><dd><label>Description <textarea rows='3' cols='20' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].description' /> </textarea></label><label> <input type='hidden' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].rating' value ='0' /></label><label> <input type='hidden' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].review_count' value ='0' /></label><label>Options <input type='text' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].options' value =' ' /></label></dd><dd><label>Vegetarian <input type='hidden' name='categories[" + (catcounter-2) + "].dishes[" + dishplace + "].vegetarian' value='0' /><input type='checkbox' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].vegetarian' value ='1' /></label><label><b>|</b> Vegan <input type='hidden' name='categories[" + (catcounter-2) + "].dishes[" + dishplace + "].vegan' value='0' /><input type='checkbox' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].vegan' value ='1' /></label><label><b>|</b> Kosher <input type='hidden' name='categories[" + (catcounter-2) + "].dishes[" + dishplace + "].kosher' value='0' /><input type='checkbox' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].kosher' value ='1' /></label><label><b>|</b> Dairy-Free <input type='hidden' name='categories[" + (catcounter-2) + "].dishes[" + dishplace + "].dairyfree' value='0' /><input type='checkbox' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].dairyfree' value ='1' /></label><label><b>|</b> Contains Peanuts <input type='hidden' name='categories[" + (catcounter-2) + "].dishes[" + dishplace + "].peanutallergy' value='0' /><input type='checkbox' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].peanutallergy' value ='1' /></label><label><b>|</b> Low-Fat <input type='hidden' name='categories[" + (catcounter-2) + "].dishes[" + dishplace + "].lowfat' value='0' /><input type='checkbox' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].lowfat' value ='1' /></label><label><b>|</b> Chef Recommended <input type='hidden' name='categories[" + (catcounter-2) + "].dishes[" + dishplace + "].chefrecommended' value='0' /><input type='checkbox' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].chefrecommended' value ='1' /></label><label><b>|</b> Spice Meter <input type='number' name = 'categories[" + (catcounter-2) + "].dishes[" + dishplace + "].spicemeter' value ='0' style = 'width:50px'/></label></dd><hr>";
          document.getElementById(divName).appendChild(newdiv);
          dishcounter++;
		  dishplace++;
}
</script>
</head>

<body>
<p> Fill out the form below to create your Menyou! </p>
<form id="testForm" action="javascript:test()">
	<dl>
		<dt><label for="currency">Currency:</label></dt>
		<dd><input id="currency" type="text" name="currency"/></dd>
	</dl>
<div id="dynamicInput">
		
</div>

<input type="button" value="Start a new category" onClick="addInput('dynamicInput');">	
<input type="button" value="Add another dish" onClick="addInput2('dynamicInput');">		

	<dl>
		<dt></dt>
		<dd><input type="submit" /></dd>
	</dl>
</form>

<pre><code id="testArea">
</code></pre>

<script type="text/javascript" src="../src/form2object.js"></script>
<script type="text/javascript" src="json2.js"></script>
<script type="text/javascript">
	function test()
	{
		var formData = form2object('testForm', '.', true,
				function(node)
				{
					if (node.id && node.id.match(/callbackTest/))
					{
						return { name: node.id, value: node.innerHTML };
					}
				});

		//document.getElementById('testArea').innerHTML = JSON.stringify(formData, null, '\t');
		
		var base = "http://www.menyouapp.com/createMenu.php?username=";
		var usn =  "<?php echo $_GET['username'] ?>";
		var basename = "&name=";
		var name = "<?php echo $_GET['name'] ?>";
		var basesess = "&sessionid=";
		var sess = "<?php echo $_GET['sessionid'] ?>";
		var data = "&data=";
		var jsonData = JSON.stringify(formData, null)
		
		window.location.href = base + usn + basename + name + basesess + sess + data + jsonData;
	}
</script>
</body>
</html>