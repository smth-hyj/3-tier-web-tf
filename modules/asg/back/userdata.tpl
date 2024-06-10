#!/bin/bash
yum -y update
yum -y install php
cat<<EOF>/php/index.php
<html>
<body>

Welcome <?php echo $_GET["name"]; ?><br>
Your email address is: <?php echo $_GET["email"]; ?>

</body>
</html>
EOF

