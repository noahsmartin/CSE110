<?php

$id = htmlspecialchars($_GET["id"]);
$position = htmlspecialchars($_GET["position"]);
header("Content-Type: image/jpeg");


$filename = "/var/www/uploads/".$id."/";
$i = 0;
$name = "";
$array = glob($filename."*.jpg");
usort($array, create_function('$a,$b', 'return filemtime($a) - filemtime($b);'));
foreach($array as $thename)
{
if($i == $position)
{
$name = $thename;
break;
}
$i++;
}
header("Content-Length: ". filesize($name));

$fp = fopen($name, 'rb');

fpassthru($fp);
exit();