<?php
  $newMenuName = $_GET['newmenuname'];
  $newMenuData = $_GET['newmenudata'];

  // use file_put_contents() to get data written
  if (json_decode($newMenuData) != NULL) // Ensure that newMenuData is valid JSON!
  {
    // Pretty print the JSON so we can read it server-side (for debugging).
    $dataAsLine = json_decode($newMenuData);
    $prettyData = json_encode($dataAsLine,JSON_PRETTY_PRINT);
    echo "Attempting to write data:<br />";
    echo $prettyData."<br />";
    // $writelen = file_put_contents("/u/acsweb/17/017/gplin/write/cs110x/menus/".$newMenuName.".json",$prettyData);
    /*
    if ($writelen != strlen($prettyData))
    {
      echo "Uh oh! Write length didn't match!<br />";
    }
    */
  }
  else
  {
    echo "newmenudata was not valid JSON!<br />";
    echo "Write operation aborted.<br />";
  }
?>
