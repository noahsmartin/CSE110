<?php

    if(!isset($_GET['username']) || !isset($_GET['sessionid']) || !isset($_GET['data']))
    {
        die();
    }
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
     
    // This tells the web browser that your content is encoded using UTF-8 
    // and that it should submit content back to you using UTF-8 
    header('Content-Type: text/html; charset=utf-8'); 
    
    $query = "SELECT session,business FROM users WHERE email = :email";
        $query_params = array( 
            ':email' => $_GET['username'] 
        ); 
        
        
            try 
        { 
            // Execute the query 
            $stmt = $db->prepare($query); 
            $result = $stmt->execute($query_params);
            $row = $stmt->fetch(); 
            if($row)
            {
                if($row['session'] == $_GET['sessionid'])
                {
                    if($_GET['name'] == $row['business'])
                    {
                        $data = json_decode($_GET['data'], TRUE);
                        $categories = $data['categories'];
                        $query = "SELECT categories FROM menu WHERE menuid = :menuid";
                                    $query_params = array( 
                                   ':menuid' => $_GET['name'] 
                                 );
                        $stmt = $db->prepare($query); 
                        $result = $stmt->execute($query_params);
                        $row = $stmt->fetch();

                        $storedcategories = json_decode($row['categories'], TRUE);
                        print_r($storedcategories);
                        foreach($categories as $category)
                        {
                            // This loops over the input data categories, all of these should be dropped from the table
                            
                            // TODO: drop then add back the updated category
                            // TODO: for each category loop over each dish and do the same for dishes
                            $id = $category['categoyid'];
                            if(in_array($id, $storedcategories))
                            {
                                echo "deleting: ", $id;
                                // Drop the row in categories that is $id
								$query = "DELETE FROM category WHERE categoryid = :id";
											$query_params = array( 
										   ':id' => $id
										 );
								$stmt = $db->prepare($query); 
								$result = $stmt->execute($query_params);
                            }
                        }
                        // Replace this new array of categories with the categories in the menu table
                        // Edit the row in menu table with my restaurant to contain my categories
                    }
                    
                    
                    
                    
                    
                }
            }
        } 
        catch(PDOException $ex) 
        { 
            // Note: On a production website, you should not output $ex->getMessage(). 
            // It may provide an attacker with helpful information about your code.  
            die("Failed to run query: " . $ex->getMessage()); 
        }