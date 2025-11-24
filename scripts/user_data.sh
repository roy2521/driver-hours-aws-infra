#!/bin/bash

# Log user-data output to file + system log
exec > >(tee -a /var/log/user-data.log | logger -t user-data) 2>&1

####################
# 1. Install Apache
####################
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# HTML page
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

##############################################
# 2. CloudWatch Agent Installation
##############################################
yum install -y amazon-cloudwatch-agent

##############################################
# 3. Create CloudWatch Agent Config 
##############################################
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/web/${env_name}/logs",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/user-data.log",
            "log_group_name": "/web/${env_name}/user_data",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF

##############################################
# 4. Start CloudWatch Agent
##############################################
amazon-cloudwatch-agent-ctl -a start

echo "CloudWatch Agent configured and started successfully"

