<?php
  switch($_GET['do'])
  {
  case 'login':
    include 'login.php';
    break;
  case 'logout':
    include 'logout.php';
    break;
  case 'getSetting':
    include 'getsetting.php';
    break;
  case 'setSetting':
    include 'setsetting.php';
    break;
  case 'loginFB':
    include 'loginfb.php';
    break;
  case 'noArg':
    include 'noarg.php';
    break;
  case 'fetchMenu':
    include 'fetchmenu.php';
    break;
  case 'writeMenu':
    include 'writemenu.php';
    break;
  case '':
    echo "no function call";
    break;
  default:
    echo "bad function call!";
  }
?>
