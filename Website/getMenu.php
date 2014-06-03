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


header('Content-Type: application/json');
header('Cache-Control: no-cache, no-store, must-revalidate'); // HTTP 1.1.
header('Pragma: no-cache'); // HTTP 1.0.
header('Expires: 0'); // Proxies.
if(!isset($_GET["ids"])) {
    echo "No provided ids";
    die();
}
$return = array();
$arr = explode(",", $_GET["ids"]);
$len = count($arr);
for($i = 0; $i < $len; $i++)
{
    // Get row with restaurant id from menus table
    $query = "SELECT currency,categories,numberdishes FROM menu WHERE menuid = :id";
    $query_params = array( 
        ':id' => $arr[$i]
    );
    try 
    { 
        // Execute the query 
        $stmt = $db->prepare($query); 
        $result = $stmt->execute($query_params);
        $row = $stmt->fetch();
        if($row)
        {
            // $menu will be the object added to the return array, it contains Found: true,
            // the number of dishes, and the categories
            $menu = array("Found" => true, "numdishes" => $row["numberdishes"]);
            $categorynames = json_decode($row["categories"]);
            $categories = array();
            for($j = 0; $j < count($categorynames); $j++)
            {
                // Add the categories
                $category = array("categoryid" => $categorynames[$j]);
                $query = "SELECT title,dishes FROM category WHERE categoryid = :id";
                $query_params = array(':id' => $categorynames[$j]);
                $stmt = $db->prepare($query); 
                $result = $stmt->execute($query_params);
                $row = $stmt->fetch();
                $category["title"] = $row["title"];
                $dishnames = json_decode($row["dishes"]);
                $dishes = array();
                for($k = 0; $k < count($dishnames); $k++)
                {
                    // Add everything else here
                    $dish = array("dishid" => $dishnames[$k]);
                    $query = "SELECT name,price,description,options,vegetarian,vegan,kosher,lowfat,dairyfree,peanutallergy,spicemeter,chefrecommended,averagerating,numberratings FROM dish WHERE dishid = :id";
                    $query_params = array(':id' => $dishnames[$k]);
                    $stmt = $db->prepare($query); 
                    $result = $stmt->execute($query_params);
                    $row = $stmt->fetch();
                    $dish["title"] = $row["name"];
                    $dish["description"] = $row["description"];
                    $dish["price"] = $row["price"];
                    $dish["options"] = $row["options"];
                    $dish["vegetarian"] = $row["vegetarian"];
                    $dish["vegan"] = $row["vegan"];
                    $dish["kosher"] = $row["kosher"];
                    $dish["lowfat"] = $row["lowfat"];
                    $dish["dairyfree"] = $row["dairyfree"];
                    $dish["peanutallergy"] = $row["peanutallergy"];
                    $dish["spicemeter"] = $row["spicemeter"];
                    $dish["chefrecommended"] = $row["chefrecommended"];
                    $dish["rating"] = $row["averagerating"];
                    $dish["review_count"] = $row["numberratings"];
                    $dishes[$k] = $dish;
                }
                $category["dishes"] = $dishes;
                $categories[$j] = $category;
            }
            // Loop over the found categories and add them to $menu...
            $menu["categories"] = $categories;
            $return[$i] = $menu;
        }
        // If the row was not found, add Found: false to the result
        else {
            $return[$i] = array("Found" => false);
        }
    }
    catch(PDOException $ex) 
    { 
        die("Error occurred");
    }
}
echo json_encode($return);