#!/bin/bash

exec > >(tee /var/log/user-data.log | logger -t user-data) 2>&1
set -x

# Update and install required packages
apt-get update -y
apt-get install -y apache2 php php-mysqlnd unzip curl

# Enable PHP module and restart Apache
a2enmod php
systemctl restart apache2
systemctl enable apache2

# Create a welcome page
echo "<html><h1>Welcome to your Apache Web Server</h1></html>" > /var/www/html/index.html

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

# Fetch RDS details from SSM
DB_ENDPOINT=$(aws ssm get-parameter --name "/webapp/rds/endpoint" --query "Parameter.Value" --output text)
DB_USERNAME=$(aws ssm get-parameter --name "/webapp/rds/username" --with-decryption --query "Parameter.Value" --output text)
DB_PASSWORD=$(aws ssm get-parameter --name "/webapp/rds/password" --with-decryption --query "Parameter.Value" --output text)

# Remove port if it exists in DB_ENDPOINT
DB_ENDPOINT=$(echo $DB_ENDPOINT | sed 's/:3306//')

# test connection to RDS
sudo bash -c "printf '<?php\n\$servername = \"%s\";\n\$username = \"%s\";\n\$password = \"%s\";\n\$dbname = \"mysql\";\n\n\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);\n\nif (\$conn->connect_error) {\n    die(\"Connection failed: \" . \$conn->connect_error);\n}\necho \"Connected to RDS Database successfully!!!\";\n\$conn->close();\n?>' \"$DB_ENDPOINT\" \"$DB_USERNAME\" \"$DB_PASSWORD\" > /var/www/html/db_test.php"

# Set permissions for the PHP file
chmod 644 /var/www/html/db_test.php

# Restart Apache to apply changes
systemctl restart apache2































# #!/bin/bash
# # Update and install required packages
# apt-get update -y
# apt-get install -y apache2 php php-mysqlnd awscli

# # Start and enable Apache
# systemctl start apache2
# systemctl enable apache2

# # Create a welcome page
# echo "<html><h1>Welcome to your Apache Web Server</h1></html>" > /var/www/html/index.html

# # Fetch RDS details from SSM
# DB_ENDPOINT=$(aws ssm get-parameter --name "/myapp/rds/endpoint" --query "Parameter.Value" --output text)
# DB_USERNAME=$(aws ssm get-parameter --name "/myapp/rds/username" --with-decryption --query "Parameter.Value" --output text)
# DB_PASSWORD=$(aws ssm get-parameter --name "/myapp/rds/password" --with-decryption --query "Parameter.Value" --output text)

# # Validate SSM Parameter Fetch
# if [ -z "$DB_ENDPOINT" ] || [ -z "$DB_USERNAME" ] || [ -z "$DB_PASSWORD" ]; then
#     echo "Failed to fetch RDS parameters from SSM. Exiting."
#     exit 1
# fi

# # Create the database test PHP page
# cat <<EOF > /var/www/html/db_test.php
# <?php
# \$servername = "${DB_ENDPOINT}";
# \$username = "${DB_USERNAME}";
# \$password = "${DB_PASSWORD}";
# \$dbname = "mydb";

# \$conn = new mysqli(\$servername, \$username, \$password, \$dbname);

# if (\$conn->connect_error) {
#     die("Connection failed: " . \$conn->connect_error);
# }
# echo "Connected successfully";
# \$conn->close();
# ?>
# EOF

# # Set permissions for the PHP file
# chmod 644 /var/www/html/db_test.php

# # Restart Apache to apply changes
# systemctl restart apache2

# # Provide a status message
# echo "Setup complete. Visit http://<your-lb-dns-name>/db_test.php to test database connection."

# # Check if db_test.php exists and log the result
# if [ -f /var/www/html/db_test.php ]; then
#     echo "db_test.php successfully created" >> /var/log/deploy.log
# else
#     echo "db_test.php not found" >> /var/log/deploy.log
# fi




# #!/bin/bash
# # Update and install required packages
# apt-get update -y
# apt-get install -y apache2 php php-mysqlnd awscli

# # Start and enable Apache
# systemctl start apache2
# systemctl enable apache2

# # Create a welcome page
# echo "<html><h1>Welcome to your Apache Web Server</h1></html>" > /var/www/html/index.html

# # Fetch RDS details from SSM (optional, for db_test.php)
# DB_ENDPOINT=$(aws ssm get-parameter --name "/myapp/rds/endpoint" --query "Parameter.Value" --output text)
# DB_USERNAME=$(aws ssm get-parameter --name "/myapp/rds/username" --with-decryption --query "Parameter.Value" --output text)
# DB_PASSWORD=$(aws ssm get-parameter --name "/myapp/rds/password" --with-decryption --query "Parameter.Value" --output text)

# # Create the database test PHP page
# cat <<EOF > /var/www/html/db_test.php
# <?php
# \$servername = "${DB_ENDPOINT}";
# \$username = "${DB_USERNAME}";
# \$password = "${DB_PASSWORD}";
# \$dbname = "mydb";

# \$conn = new mysqli(\$servername, \$username, \$password, \$dbname);

# if (\$conn->connect_error) {
#     die("Connection failed: " . \$conn->connect_error);
# }
# echo "Connected successfully";
# \$conn->close();
# ?>
# EOF



