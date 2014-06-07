<?php

$id = htmlspecialchars($_GET["id"]);
$position = htmlspecialchars($_GET["count"]);
header("Content-Type: image/jpeg");


$filename = "/var/www/uploads/".$id."/thumb/";
$i = 0;
$name = "";
$array = glob($filename."*.jpg");
usort($array, create_function('$a,$b', 'return filemtime($a) - filemtime($b);'));
foreach($array as $filename)
{
if($i == $position)
{
$name = $filename;
break;
}
$i++;
}
header("Content-Length: ". filesize($name));

$fp = fopen($name, 'rb');

fpassthru($fp);
exit();