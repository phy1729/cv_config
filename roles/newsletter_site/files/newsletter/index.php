<?php
	$newsletters=glob('*.pdf');
	rsort($newsletters);
?>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" type="text/css" href="http://collegiumv.org/style.css" />
		<title>CV Newsletters</title>
	</head>
	<body>
		<div id="container">
			<div id="header"></div>
			<div id="main">
				<h1>CV Newsletters</h1>
				<ul>
					<?php
						foreach ($newsletters as $newsletter) {
							echo '<li><a href="',$newsletter,'">',date('M Y',strtotime(trim($newsletter,'.pdf').'01')),'</a></li>';
						}
					?>
				</ul>
			</div>
			<div id="footer"></div>
		</div>
	</body>
</html>
