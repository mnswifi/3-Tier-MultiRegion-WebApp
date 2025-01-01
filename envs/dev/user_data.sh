#!/bin/bash
apt-get update -y
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<html><h1>Welcome to your Apache Web Server</h1></html>" > /var/www/html/index.html

#!/bin/bash
    # yum update -y
    # yum install -y httpd php php-mysqlnd

    # systemctl start httpd
    # systemctl enable httpd

    # cat <<'INNER_EOF' > /var/www/html/db_test.php
    # <?php
    # $servername = "${aws_db_instance.mydb.endpoint}";
    # $username = "admin";
    # $password = "admin1234";
    # $dbname = "mydb";

    # $conn = new mysqli($servername, $username, $password, $dbname);

    # if ($conn->connect_error) {
    #     die("Connection failed: " . $conn->connect_error);
    # }
    # echo "Connected successfully";
    # $conn->close();
    # ?>
    # INNER_EOF

    # systemctl restart httpd
    