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
            ':email' => $_GET['email'] 
        ); 

       $email = $_GET['email'];
         
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
            if($_GET['session'] === $row['session']) 
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
        { 
            $query = "SELECT * FROM reviews WHERE userid = '$email'";
            try {
                $stmt = $db->prepare($query);
                $result = $stmt->execute($query_params);
            }
            catch(PDOException $ex)
            {
                // Note: On a production website, you should not output $ex->getMessage(). 
                // It may provide an attacker with helpful information about your code.  
                die("Failed to run query: " . $ex->getMessage()); 
            }
            $reviews = array();
            while($row = $stmt->fetch())
            {
                $reviews[$row['dishid']] = $row['rating'];
            } 
            $loginGood = array('Status' => "Success");
            $loginGood['Reviews'] = $reviews;
            echo json_encode($loginGood);
            die();
            
        }