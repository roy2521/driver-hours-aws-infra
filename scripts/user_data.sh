#!/bin/bash
yum install -y httpd
systemctl start httpd
systemctl enable httpd

cat <<EOF > /var/www/html/index.html
<html>
  <body style="background-color:#f4f4f4; font-family:Arial; text-align:center;">
    <h1 style="color:#2a4dff;">Welcome to Worklog System 🚚</h1>
    <h2 style="color:#444;">Instance: <span style="color:#e63946;">$(hostname -f)</span></h2>
    <p style="font-size:18px; color:#333;">
      Served via Auto Scaling Group + Load Balancer
    </p>
  </body>
</html>
EOF

