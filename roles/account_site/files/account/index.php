<?php
$key=@$_GET['key'];
$netID=@strtolower($_GET['netID']);
$username=@$_GET["username"];

require_once('config/config.php');

$ldap = ldap_connect($ldap_server, $ldap_port);
if (!$ldap) {
	CVlog('Could not connect to LDAP server.');
	echo "The account page is currently unavailable. Please email cvadmins@utdallas.edu for assistance.";
	exit();
}
ldap_set_option($ldap, LDAP_OPT_PROTOCOL_VERSION, 3);
if (!ldap_bind($ldap, $ldap_admin_username, $ldap_admin_password)) {
	CVlog("Could not bind to LDAP server");
	echo "The account page is currently unavailable. Please email cvadmins@utdallas.edu for assistance.";
	exit();
}

if(!empty($key) && isValidNetID($netID)) { // Received confirmation key; reset pass or create account
	if (hasAccount($netID)) {
		if (isValidKey($key, $netID)) {
			$content = resetUserPassword($netID);
		} else {
			if (!empty($username)) $content = "You've already created your account! (You've probably refreshed the page or clicked the link more than once.)";
			else $content = 'Invalid Key.';
		}
	} elseif (!inACL($netID)) {
		$content = 'Unknown netID';
	} elseif (!isValidUsername($username)) {
		$content = 'Invalid username';
	} elseif (!isValidKey($key, $netID, $username)) {
		$content = 'Invalid key.';
	} else {
		$content = createUser($netID, $username);
	}
} elseif (isValidNetID($netID)) { // If we already have a netID, send a confirmation email
	if (hasAccount($netID)) {
		$content = sendResetEmail($netID);
	} elseif (inACL($netID)) {
		if (isValidUsername($username)) { // Need a username too if it's a new user
			$content = sendCreationEmail($netID, $username);
		} else {
			if (!empty($username)) $content = 'Error: Invalid username <br />';
			@$content .= 'Enter your desired username to continue creating your account:
				<form action="index.php" method="get">
				<input type="hidden" name="netID" value="'.$netID.'">
				<input type="text" size="9" name="username" />
				<input type="submit" value="Submit"/>
				</form>';
		}
	} else {
		$content = 'Sorry, your netID ('.$netID.') is not recognized. Please email <a href="mailto:cvadmins@utdallas.edu">cvadmins@utdallas.edu</a> for assistance.';
	}
} else { //else get the netID
	if (!empty($netID)) $content = 'Error: Invalid netID. <br />';
	@$content .= 'Enter your netID to reset your password or create an account:
		<form action="index.php" method="get">
		<input type="text" size="9" name="netID" />
		<input type="submit" value="Submit"/>
		</form>';
}

function isValidNetID($netID) {
	return preg_match("/^[a-z]{3}[0-9]{6}$/", $netID); // This will fail for older netIDs but that shouldn't matter
}

function isValidUsername($username) {
	return preg_match("/^[A-Za-z0-9.-_]{1,30}$/", $username);
}

function isValidKey($key, $netID, $username="") {
	if (empty($username)) {
		if ($key === getKey($netID) || $key === getKey($netID, "", -1)) {
			return true;
		}
	} else {
		if ($key === getKey($netID, $username) || $key === getKey($netID, $username, -1)) {
			return true;
		}
	}
	return false;
}

function resetUserPassword($netID) {
	global $ldap;
	$password=makePassword();
	$result = ldap_modify($ldap, getDNFromNetID($netID), array('unicodePwd' => encodePassword($password), 'pwdLastSet' => '0'));
	if ($result) {
		sendMail($netID, 'CV Password Reset', 'Your new password is "'.$password.'". This is a temporary password. To set your real password login on a lounge computer with your username ('.getUsernameFromNetID($netID).').');
		CVlog("Reset password for n:$netID");
		return "Please check your zmail for your new password. Press the \"Get Mail\" icon in the upper left to refresh your inbox.";
	} else {
		CVlog("Error resetting password for n:$netID");
		return 'There was an error resetting your password. Please email <a href="mailto:cvadmins@utdallas.edu">cvadmins@utdallas.edu</a> for assistance.';
	}
}

function sendResetEmail($netID) {
	sendMail($netID, 'CV Password Reset', 'A password reset was requested for your account. If you did not request this, please disregard this email. To complete the password reset click on the following link.'."\n".getLink($netID));
	CVlog("Sent reset email for n:$netID");
	return "Please check your zmail to finish resetting your password.";
}

function createUser($netID, $username) {
	global $ldap, $base_dn;
	$user=getUser($netID);
	$first=$user[FIRST_NAME];
	$last=$user[LAST_NAME];
	$password=makePassword();
	$user_attributes['samaccountname'][0] = $username;
	$user_attributes['userPrincipalName'][0] = $username . '@collegiumv.org';
	$user_attributes['givenName'][0] = $first;
	$user_attributes['sn'][0] = $last;
	$user_attributes['displayname'][0] = $first . ' ' . $last;
	$user_attributes['name'][0] = $first . ' ' . $last;
	$user_attributes['cn'][0] = $first . ' ' . $last;
	$user_attributes['mail'][0] = $netID . '@utdallas.edu';
	$user_attributes['description'][0] = $netID;
	$user_attributes['unicodePwd'] = encodePassword($password);
	$user_attributes['pwdlastset'][0] = 0;
	$user_attributes['objectclass'][0] = 'top';
	$user_attributes['objectclass'][1] = 'person';
	$user_attributes['objectclass'][2] = 'organizationalPerson';
	$user_attributes['objectclass'][3] = 'user';
	$user_attributes['userAccountControl'][0] = 512; // NORMAL_ACCOUNT
	$user_attributes['uidNumber'][0] = getnextUID();
	$result = ldap_add($ldap, "CN=" . $first . " " . $last . ", " . $base_dn, $user_attributes);
	if ($result) {
		sendMail($netID, 'CV Account Creation', 'Your new password is "'.$password.'". This is a temporary password. To set your real password login on a lounge computer.');
		CVlog("Made account for $first $last u:$username n:$netID");
		return  "Please check your zmail to finish creating your account. Press the \"Get Mail\" icon in the upper left to refresh your inbox.";
	} else {
		CVlog("Error creating account for n:$netID");
		return 'There was an error creating your account. Please email <a href="mailto:cvadmins@utdallas.edu">cvadmins@utdallas.edu</a> for assistance.';
	}
}

function sendCreationEmail($netID, $username) {
	sendMail($netID, 'CV Account Creation', 'An account creation was requested for your netID. If you did not request this, please disregard this email. To finish creating the account click on the following link.'."\n".getLink($netID, $username));
	CVlog("Sent creation email for u:$username n:$netID");
	return "Please check your zmail to finish creating your account.";
}

function sendMail($netID, $subject, $body) {
	mail($netID.'@utdallas.edu', $subject, $body, 'From:cthulhu@collegiumv.org');
}

function makePassword() {
	$word_filename="config/words.txt";
	$word_handle=fopen($word_filename, "r");
	$words=explode("\r\n", fread($word_handle, filesize($word_filename)));
	$keys=array_rand($words, 3);
	fclose($word_handle);
	$password="";
	foreach ($keys as $key) {
		$password .=ucfirst(strtolower($words[$key]));
	}
	return $password;
}

function encodePassword($password) {
	return mb_convert_encoding('"' . $password . '"', 'UTF-16LE');
}

function hasAccount($netID) {
	return (getUsernameFromNetID($netID) !== false);
}

function getUsernameFromNetID($netID) {
	global $ldap, $base_dn;
	$search=ldap_search($ldap, $base_dn, "(description=$netID)");
	$search_results=ldap_get_entries($ldap, $search);
	if ($search_results["count"] === 1) {
		return $search_results[0]['samaccountname'][0];
	} elseif ($search_results["count"] === 0) {
		return false;
	} else {
		CVLog("Too many matches for ".$netID);
		echo "There has been an error. Please contact cvadmins@utdallas.edu .";
		exit();
	}
}

function getDNFromNetID($netID) {
	global $ldap, $base_dn;
	$search=ldap_search($ldap, $base_dn, "(description=$netID)");
	$search_results=ldap_get_entries($ldap, $search);
	if ($search_results["count"] === 1) {
		return $search_results[0]['dn'];
	} elseif ($search_results["count"] === 0) {
		CVLog("No matches for ".$netID);
		return false;
	} else {
		CVLog("Too many matches for ".$netID);
		return false;
	}
}

function getNextUID($max = 0) {
	global $ldap, $base_dn;
	$search=ldap_search($ldap, $base_dn, "(|(uidNumber>=" . $max . ")(uidNumber=" . $max . "))", array('uidNumber'));
	$search_results=ldap_get_entries($ldap, $search);
	if ($search_results["count"] === 1) {
		return $search_results[0]['uidnumber'][0] + 1;
	} elseif ($search_results === NULL) {
		CVLog('No UIDs!');
		echo "There has been an error. Please contact cvadmins@utdallas.edu .";
		exit();
	} else {
		foreach ($search_results as $result) {
			if ($result['uidnumber'][0] > $max)
				$max = $result['uidnumber'][0];
		}
		return getNextUID($max);
	}
}

function getACL() {
	$ACL_filename="config/access.list";
	@define("FIRST_NAME", 1);
	@define("LAST_NAME", 0);
	@define("NETID", 2);

	$ACL_handle=fopen($ACL_filename, "r");
	$lines=explode("\n", fread($ACL_handle, filesize($ACL_filename)));
	foreach ($lines as $line) {
		if ($line === '' || $line[0] === '#') {
			continue;
		}
		$ACL[]=explode(',', $line);
	}
	fclose($ACL_handle);
	return $ACL;
}

function inACL($netID) {
	return (getUser($netID) !== false);
}

function getUser($netID) {
	$ACL=getACL();

	foreach ($ACL as $person) {
		if ($person[NETID] === $netID) {
			return $person;
		}
	}
	return false;
}

function getLink($netID, $username="") {
	if (!empty($username)) {
		return 'http://account.collegiumv.org/index.php?netID='.$netID.'&username='.$username.'&key='.getkey($netID, $username);
	} else {
		return 'http://account.collegiumv.org/index.php?netID='.$netID.'&key='.getkey($netID);
	}
}
function getKey($netID, $username="", $past=0) {
	global $config_salt;
	$date = new DateTime();
	$date->modify($past.' day');
	$data = strtolower($netID).$date->format('Y-m-d');
	if (!empty($username)) $data .= $username;
	return hash_hmac("sha256", $data, $config_salt);
}

function CVlog($text) {
	$logfile="config/account.log";
	$handle=fopen($logfile, "a");
	fwrite($handle, date(DateTime::ISO8601).'  '.$text."\n");
	fclose($handle);
}

?>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="http://collegiumv.org/style.css" />
<title>CV Accounts Webpage</title>
</head>
<body>
<div id="container">
  <div id="header"></div>
  <div id="main">
   <div id="content">
    <?php echo $content ?>
   </div>
  </div>
<div id="footer"></div>
</div>
</body>
</html>
