<?php
    header("Content-Type: text/json");


    // These variables define the connection information
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
     
    // This block of code is used to undo magic quotes.
    if(function_exists('get_magic_quotes_gpc') && get_magic_quotes_gpc()) 
    { 
        function undo_magic_quotes_gpc(&$array) 
        { 
            foreach($array as &$value) 
            { 
                if(is_array($value)) 
                { 
                    undo_magic_quotes_gpc($value); 
                } 
                else 
                { 
                    $value = stripslashes($value); 
                } 
            } 
        } 
     
        undo_magic_quotes_gpc($_POST); 
        undo_magic_quotes_gpc($_GET); 
        undo_magic_quotes_gpc($_COOKIE); 
    } 
          
        // This query retrieves the user's information from the database using 
        // their email. 
        $query = " 
            SELECT 
                email,
                session
            FROM users 
            WHERE 
                email = :email 
        "; 
         
        // The parameter values 
        $query_params = array( 
            ':email' => $_POST['email'] 
        ); 

       $email = $_POST['email'];
         
        try 
        { 
            // Execute the query against the database 
            $stmt = $db->prepare($query); 
            $result = $stmt->execute($query_params); 
        } 
        catch(PDOException $ex) 
        { 
            // Note: On a production website, you should not output $ex->getMessage(). 
            // It may provide an attacker with helpful information about your code.  
            die("Failed to run query: " . $ex->getMessage()); 
        } 
         
        // This variable tells us whether the user has successfully logged in or not. 
        // We initialize it to false, assuming they have not. 
        // If we determine that they have entered the right details, then we switch it to true. 
        $login_ok = false; 
         
        // Retrieve the user data from the database.  If $row is false, then the email 
        // they entered is not registered. 
        $row = $stmt->fetch(); 
        if($row) 
        { 
            if($_POST['session'] == $row['session']) 
            { 
                // If they do, then we flip this to true 
                $login_ok = true;
            }
            else {
          $loginBad = array('Status' => "Failure", 'Message' => "Wrong password");

          echo json_encode($loginBad);
          die();
         }
        } 
         
        if($login_ok) 
        {   //Store the review in the reviews table
            $query = "INSERT INTO reviews VALUES (:userid, :dishid, :rating)";
            $query_params = array( 
                ':userid' => $_POST['email'],
                ':dishid' => $_POST['item'],
                ':rating' => $_POST['rating']
            );
                     
            try 
            { 
                // Execute the query against the database 
                $stmt = $db->prepare($query); 
                $result = $stmt->execute($query_params); 
            } 
            catch(PDOException $ex) 
            { 
                // Note: On a production website, you should not output $ex->getMessage(). 
                // It may provide an attacker with helpful information about your code.  
                die("Failed to run query: " . $ex->getMessage());
            }
			
            //Grab the dish's old review stats
		    $query = "SELECT averagerating, numberratings FROM dish WHERE dishid = :dishid";
            $query_params = array(
                ':dishid' => $_POST['item']
            );
                     
            try 
            { 
                // Execute the query against the database 
                $stmt = $db->prepare($query); 
                $result = $stmt->execute($query_params); 
            } 
            catch(PDOException $ex) 
            { 
                // Note: On a production website, you should not output $ex->getMessage(). 
                // It may provide an attacker with helpful information about your code.  
                die("Failed to run query: " . $ex->getMessage());
            }
			
			$row = $stmt->fetch();
			$score = $row['averagerating'];
			$newtotal = $row['numberratings'] + 1;
			$input = $_POST['rating'];
			$avg = round((($score * $row['numberratings']) + $input )/ $newtotal, 3, PHP_ROUND_HALF_UP);
			
			//Update the dish review stats
			$query = "UPDATE dish SET averagerating = '$avg', numberratings = '$newtotal' WHERE dishid = :dishid";
            $query_params = array(
                ':dishid' => $_POST['item']
            );
                     
            try 
            { 
                // Execute the query against the database 
                $stmt = $db->prepare($query); 
                $result = $stmt->execute($query_params); 
            } 
            catch(PDOException $ex) 
            { 
                // Note: On a production website, you should not output $ex->getMessage(). 
                // It may provide an attacker with helpful information about your code.  
                die("Failed to run query: " . $ex->getMessage());
            }
			
            if(isset($_FILES["file"]))
            {
                $path = "/var/www/uploads/".$_POST['item']."/";
                verify_path($path);
                move_uploaded_file($_FILES["file"]["tmp_name"], $path.$_FILES["file"]["name"]);
                $newPath = $path ."thumb/";
                verify_path($newPath);
                make_thumb($path.$_FILES["file"]["name"], $newPath.$_FILES["file"]["name"], 100);
            }
        }
        
        function verify_path($path)
        {
            if(!is_dir($path))
                mkdir($path);
        }
        
function make_thumb($src, $dest, $desired_width) {

	/* read the source image */
	$source_image = imagecreatefromjpeg($src);
	$width = imagesx($source_image);
	$height = imagesy($source_image);
	
	/* find the "desired height" of this thumbnail, relative to the desired width  */
	$desired_height = floor($height * ($desired_width / $width));
	
	/* create a new, "virtual" image */
	$virtual_image = imagecreatetruecolor($desired_width, $desired_height);
	
	/* copy source image at a resized size */
	imagecopyresampled($virtual_image, $source_image, 0, 0, 0, 0, $desired_width, $desired_height, $width, $height);
	
	/* create the physical thumbnail image to its destination */
	imagejpeg($virtual_image, $dest, 100);
}