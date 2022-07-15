#! /bin/bash
echo "Starting Setting up the bootstrap scripts"
sudo yum -y update
sudo amazon-linux-extras install java-openjdk11 -y
java -version
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-11.0.12.0.7-0.amzn2.0.2.x86_64"
PATH=$JAVA_HOME/bin:$PATH
source .bashrc
echo $JAVA_HOME
sudo groupadd --system tomcat
sudo useradd -d /usr/share/tomcat -r -s /bin/false -g tomcat tomcat
getent passwd tomcat
sudo yum -y install wget
export VER="9.0.52"
echo $VER
wget https://archive.apache.org/dist/tomcat/tomcat-9/v${VER}/bin/apache-tomcat-${VER}.tar.gz
mkdir /opt/tomcat
tar xzvf apache-tomcat-${VER}.tar.gz -C /opt/tomcat --strip-components=1
sudo chown -R tomcat:tomcat /opt/tomcat/*
sudo sh -c 'chmod +x /opt/tomcat/bin/*.sh'
echo 'Setting up tomcat service...'
sudo touch tomcat.service
sudo chmod 777 tomcat.service 
echo "[Unit]" > tomcat.service
echo "Description=Apache Tomcat Web Application Container" >> tomcat.service
echo "After=network.target" >> tomcat.service
echo "[Service]" >> tomcat.service
echo "Type=forking" >> tomcat.service
echo "User=tomcat" >> tomcat.service
echo "Group=tomcat" >> tomcat.service
echo "UMask=0007" >> tomcat.service
echo "RestartSec=10" >> tomcat.service
echo "Restart=always" >> tomcat.service
echo "Environment=JAVA_HOME=$JAVA_HOME" >> tomcat.service
echo "Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid" >> tomcat.service
echo "Environment=CATALINA_HOME=/opt/tomcat" >> tomcat.service
echo "Environment=CATALINA_BASE=/opt/tomcat" >> tomcat.service
echo "Environment=CATALINA_OPTS=-Xms1024M -Xmx2048M -server -XX:+UseParallelGC" >> tomcat.service
echo "Environment=JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom" >> tomcat.service
echo "ExecStart=/opt/tomcat/bin/startup.sh" >> tomcat.service
echo "ExecStop=/opt/tomcat/bin/shutdown.sh" >> tomcat.service
echo "[Install]" >> tomcat.service
echo "WantedBy=multi-user.target" >> tomcat.service
sudo mv tomcat.service /etc/systemd/system/tomcat.service
sudo chmod 755 /etc/systemd/system/tomcat.service
sudo systemctl daemon-reload
echo 'Starting tomcat server....'
sudo systemctl start tomcat
echo 'Started Tomcat'
echo "Installing Apache HTTP"
sudo yum install httpd -y
sudo yum install mod_ssl -y
sudo systemctl restart httpd
echo "Apache version"
httpd -v
sudo yum install epel-release
sudo yum install install certbot python3-certbot-apache
sudo yum install mod_security -y
sudo yum install mod_security_crs -y
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/httpd/conf.d/mod_security.conf
sudo sed -i 's/SecRequestBodyAccess Off/SecRequestBodyAccess On/' /etc/httpd/conf.d/mod_security.conf
sudo touch /etc/httpd/modsecurity.d/activated_rules/WHITELIST_URI.conf
sudo cat <<WHITELIST_URI >/etc/httpd/modsecurity.d/activated_rules/WHITELIST_URI.conf
#ModSecurity WHITELIST_URI#
###
SecRule REQUEST_URI "/api/rns*" "id:3001, phase:1, log, t:none, msg:'bypass all at /nes/api/rns*', allow"
WHITELIST_URI
sudo chmod 777 /etc/httpd/modsecurity.d/activated_rules/WHITELIST_URI.conf
sudo chmod 755 /var/log/httpd/modsec_debug.log 
sudo chmod 755 /var/log/httpd/modsec_audit.log 
echo "Created mod security Whitelist"
sudo systemctl restart httpd
echo "Restarted HTTPD"
echo "Tomcat Configuration"

echo "Removing </tomcat-users> from tomcat-users.xml file"
LINE_NO=`grep -n "</tomcat-users>" /opt/tomcat/conf/tomcat-users.xml | cut -d: -f1 | head -1`
LINE_CONTENT=""
sed -i "${LINE_NO}s@.*@${LINE_CONTENT}@" /opt/tomcat/conf/tomcat-users.xml
echo "Removed </tomcat-users> from tomcat-users.xml file"
# admin account applied to host-manager
TOMCAT_ADMIN_ID="tomcatadmin"
TOMCAT_ADMIN_PASSWORD="T0mc@t@dminS3cr3t"
echo $TOMCAT_ADMIN_ID
echo $TOMCAT_ADMIN_PASSWORD
# manager account applied to manager
TOMCAT_MANAGER_ID="manageradmin"
TOMCAT_MANAGER_PASSWORD="Manag3r@dminS3cr3t"
echo $TOMCAT_MANAGER_ID
echo $TOMCAT_MANAGER_PASSWORD
echo ""
echo '--------------------------------'
echo "  <role rolename=\"manager-gui\"/>" >> /opt/tomcat/conf/tomcat-users.xml
echo "  <user username=\"${TOMCAT_ADMIN_ID}\" password=\"${TOMCAT_ADMIN_PASSWORD}\" roles=\"manager-gui\"/>" >> /opt/tomcat/conf/tomcat-users.xml
echo " " >> /opt/tomcat/conf/tomcat-users.xml
echo "  <role rolename=\"admin-gui\"/>" >> /opt/tomcat/conf/tomcat-users.xml
echo "  <user username=\"${TOMCAT_MANAGER_ID}\" password=\"${TOMCAT_MANAGER_PASSWORD}\" roles=\"manager-gui,admin-gui\"/>" >> /opt/tomcat/conf/tomcat-users.xml
echo "  </tomcat-users>" >> /opt/tomcat/conf/tomcat-users.xml
echo "------ Updating the Hostmanager and Manager context config"
echo " "
rm -rf /opt/tomcat/webapps/host-manager/META-INF/context.xml
touch /opt/tomcat/webapps/host-manager/META-INF/context.xml
echo " "
rm -rf /opt/tomcat/webapps/manager/META-INF/context.xml
touch /opt/tomcat/webapps/manager/META-INF/context.xml
echo " "
echo "Manager"
cat <<EOT >/opt/tomcat/webapps/manager/META-INF/context.xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at
      http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
<!--
  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
-->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
EOT
echo " "
echo "Host-Manager"
cat <<EOT >/opt/tomcat/webapps/host-manager/META-INF/context.xml
<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at
      http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<Context antiResourceLocking="false" privileged="true" >
  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"
                   sameSiteCookies="strict" />
<!--
 <Valve className="org.apache.catalina.valves.RemoteAddrValve"
  allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
-->
  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>
</Context>
EOT
echo ""
sudo chown -R tomcat:tomcat /opt/tomcat/*
echo "End of Tomcat configuration"
useradd -s /bin/bash appuser
usermod -aG root appuser
echo "Completed Setting up the bootstrap scripts"