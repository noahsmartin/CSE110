<?php
  $username = $_GET['username'];
  $passhash = intval($_GET['passhash'],0);
  echo "login() called.<br />";
  echo "username was: ".$username."<br />";
  $passhashstr = sprintf('0x%X',$passhash);
  echo "passhash was: ".$passhashstr."<br />";

  // Fetch last session number from "lastsession.log"
  $lastsession = intval(file_get_contents("/u/acsweb/17/017/gplin/write/cs110x/lastsession.log"),0);
  echo "Last session was #".$lastsession."<br />";
  $currsession = $lastsession + 1;
  echo "Current session is #".$currsession."<br />";

  if ($currsession % 32 == 0)
  {
    file_put_contents("/u/acsweb/17/017/gplin/write/cs110x/sessions.log",
      "----------+--------------------+----------\nSession ID|Username            |Passhash\n----------+--------------------+----------\n",
      FILE_APPEND);
  }

  echo "attempting to write string:<br />";
  echo sprintf('%010d',$currsession)."|".sprintf('%-20s',$username)."|".sprintf('%010d',$passhash)."<br />";

  $writelen = file_put_contents("/u/acsweb/17/017/gplin/write/cs110x/sessions.log",
    sprintf('%010d',$currsession)."|".sprintf('%-20s',$username)."|".sprintf('%010d',$passhash)."\n",
    FILE_APPEND);

  if ($writelen != strlen(sprintf('%10d',$currsession)."|".sprintf('%-20s',$username)."|".sprintf('%010d',$passhash)."\n"))
  {
    echo "Uh oh! Write length does not match!<br />";
  }

  echo "updating last session...";

  $writelen = file_put_contents("/u/acsweb/17/017/gplin/write/cs110x/lastsession.log",
    sprintf('%d',$currsession));
  if ($writelen != strlen(sprintf('%d',$currsession)))
  {
    echo "Uh oh! Write length of curr session didn't match!";
  }
?>
