<?php
$id = htmlspecialchars($_GET["id"]);
$filename = "/var/www/uploads/".$id."/thumb/";
$i = 0;
foreach(glob($filename."*.jpg") as $filename)
{
$i++;
}
$result = array("count" => $i);
echo json_encode($result);
/*header("Content-Type: image/jpeg");
header("Content-Length: ". filesize($filename));

$fp = fopen($filename, 'rb');

fpassthru($fp);
exit();*/