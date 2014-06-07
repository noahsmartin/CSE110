<html>
<head>
<title>Menyou App | Reset Password</title>
</head>
<body>

<form action="passReset.php" method="post">
<input type="hidden" name="email" value=<?php echo $_GET['email'] ?>>
New Password: <input type="text" name="pass"><br />
<input type="hidden" name="reset" value=<?php echo $_GET['reset'] ?>><br />
<input type="submit">
</form>

</body>
</html>