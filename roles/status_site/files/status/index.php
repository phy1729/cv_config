<html>
	<head>
		<title>CV Status</title>
		<script src="jquery.min.js" type="text/javascript"></script>
		<script src="jquery.timeago.js" type="text/javascript"></script>
		<script>
			jQuery(document).ready(function() {
				jQuery("abbr.timeago").timeago();
			});
		</script>
	</head>
	<body>
		Last updated: <abbr class="timeago" title="<?php echo date('Y-m-d\TH:i:\0\0O') ?>"><? echo date('Y-m-d\TH:i:\0\0O') ?></abbr><br /><br />
		Daily bandwidth: <br /><img src="images/pfstat-bandwidth_day.jpg" /><br />
		Daily states: <br /><img src="images/pfstat-states_day.jpg" /><br />
		Daily errors: <br /><img src="images/pfstat-errors_day.jpg" /><br />
		Daily blocked: <br /><img src="images/pfstat-blocked_day.jpg" /><br />
		Daily users: <br /><img src="images/users_day.png" /><br />
		<br /><br />
		Weekly bandwidth: <br /><img src="images/pfstat-bandwidth_week.jpg" /><br />
		Weekly states: <br /><img src="images/pfstat-states_week.jpg" /><br />
		Weekly errors: <br /><img src="images/pfstat-errors_week.jpg" /><br />
		Weekly blocked: <br /><img src="images/pfstat-blocked_week.jpg" /><br />
		Weekly users: <br /><img src="images/users_week.png" /><br />
		<br /><br />
		H load average: <br /><img src="images/h_uptime_day.png" /><br />
		H memory usage: <br /><img src="images/h_mem_day.png" /><br />
		N load average: <br /><img src="images/n_uptime_day.png" /><br />
		N memory usage: <br /><img src="images/n_mem_day.png" /><br />
		N memory usage: <br /><img src="images/n_mem_week.png" /><br />
		N IRC usage: <br /><img src="images/n_irc_day.png" /><br />
	</body>
</html>
