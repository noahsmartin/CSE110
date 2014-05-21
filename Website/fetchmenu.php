<?php
  // Incoming info *may* be more than one menu, comma-separated. Use regex to separate.
  if (isset($_GET['menuname']))
  {
    $menuNameArray = preg_split("/[\s,]+/",$_GET['menuname'],NULL,PREG_SPLIT_NO_EMPTY);
    for ($i = 0, $argc = count($menuNameArray), $argv = array_values($menuNameArray); $i < $argc; $i++)
    {
      $menuName = $argv[$i];
      if ($i == 0) echo "[";
      if (file_exists("/u/acsweb/17/017/gplin/write/cs110x/menus/".$menuName.".json"))
      {
        include "/u/acsweb/17/017/gplin/write/cs110x/menus/".$menuName.".json";
      }
      else
      {
        echo "{ \"comment\":\"Menu not available!\", \"available\":false }";
      }
      if ($i != $argc-1) echo ", ";
      else if ($i == $argc-1) echo "]";
    }
  }
  else
  {
    echo "Oops! No menuname specified.<br />";
  }
?>
