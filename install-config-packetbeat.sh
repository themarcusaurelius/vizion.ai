#! /bin/bash
echo
echo
echo "What type of download for your system?"
echo "Enter (1)for Debian, (2)for rpm, (3)for mac, (4)for tar/linux"
read DOWNLOAD_TYPE

if [[ $DOWNLOAD_TYPE -eq 1 ]]; then
  sudo apt-get install libpcap0.8
  curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-6.5.4-amd64.deb
  sudo dpkg -i packetbeat-6.5.4-amd64.deb
elif [[ $DOWNLOAD_TYPE -eq 2 ]]; then
  sudo yum install libpcap
  curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-6.5.4-x86_64.rpm
  sudo rpm -vi packetbeat-6.5.4-x86_64.rpm
elif [[ $DOWNLOAD_TYPE -eq 3 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-6.5.4-darwin-x86_64.tar.gz
  tar xzvf packetbeat-6.5.4-darwin-x86_64.tar.gz
elif [[ $DOWNLOAD_TYPE -eq 4 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-6.5.4-linux-x86_64.tar.gz
  tar xzvf packetbeat-6.5.4-linux-x86_64.tar.gz
else
  echo "That was not one of the options. Exiting."
  exit 1
fi

USERNAME_REGEX="https://([a-zA-Z0-9]*):"
PASSWORD_REGEX=":([a-zA-Z0-9]*)@"
API_KEY_REGEX="@([a-zA-Z0-9]*).es"

if [[ $1 =~ $USERNAME_REGEX ]]; then
  USERNAME=${BASH_REMATCH[1]}
else
  echo "URL could not be parsed. Please be sure to include full URL"
  exit 1
fi

if [[ $1 =~ $PASSWORD_REGEX ]]; then
  PASSWORD=${BASH_REMATCH[1]}
else
  echo "URL could not be parsed. Please be sure to include full URL"
  exit 1
fi

if [[ $1 =~ $API_KEY_REGEX ]]; then
  API_KEY=${BASH_REMATCH[1]}
else
  echo "URL could not be parsed. Please be sure to include full URL" 
  exit 1
fi

echo "#################### Packetbeat Configuration Example #########################" > /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# This file is an example configuration file highlighting only the most common" >> /etc/packetbeat/packetbeat.yml
echo "# options. The packetbeat.reference.yml file from the same directory contains all the" >> /etc/packetbeat/packetbeat.yml
echo "# supported options with more comments. You can use it as a reference." >> /etc/packetbeat/packetbeat.yml
echo "#" >> /etc/packetbeat/packetbeat.yml
echo "# You can find the full configuration reference here:" >> /etc/packetbeat/packetbeat.yml
echo "# https://www.elastic.co/guide/en/beats/packetbeat/index.html" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#============================== Network device ================================" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# Select the network interface to sniff the data. On Linux, you can use the" >> /etc/packetbeat/packetbeat.yml
echo "# \"any\" keyword to sniff on all connected interfaces." >> /etc/packetbeat/packetbeat.yml
echo "packetbeat.interfaces.device: any" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#================================== Flows =====================================" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# Set \`enabled: false\` or comment out all options to disable flows reporting." >> /etc/packetbeat/packetbeat.yml
echo "packetbeat.flows:" >> /etc/packetbeat/packetbeat.yml
echo "  # Set network flow timeout. Flow is killed if no packet is received before being" >> /etc/packetbeat/packetbeat.yml
echo "  # timed out." >> /etc/packetbeat/packetbeat.yml
echo "  timeout: 30s" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure reporting period. If set to -1, only killed flows will be reported" >> /etc/packetbeat/packetbeat.yml
echo "  period: 10s" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#========================== Transaction protocols =============================" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "packetbeat.protocols:" >> /etc/packetbeat/packetbeat.yml
echo "- type: icmp" >> /etc/packetbeat/packetbeat.yml
echo "  # Enable ICMPv4 and ICMPv6 monitoring. Default: false" >> /etc/packetbeat/packetbeat.yml
echo "  enabled: true" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: amqp" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the ports where to listen for AMQP traffic. You can disable" >> /etc/packetbeat/packetbeat.yml
echo "  # the AMQP protocol by commenting out the list of ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [5672]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: cassandra" >> /etc/packetbeat/packetbeat.yml
echo "  #Cassandra port for traffic monitoring." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [9042]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: dhcpv4" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the DHCP for IPv4 ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [67, 68]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: dns" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the ports where to listen for DNS traffic. You can disable" >> /etc/packetbeat/packetbeat.yml
echo "  # the DNS protocol by commenting out the list of ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [53]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "  # include_authorities controls whether or not the dns.authorities field" >> /etc/packetbeat/packetbeat.yml
echo "  # (authority resource records) is added to messages." >> /etc/packetbeat/packetbeat.yml
echo "  include_authorities: true" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "  # include_additionals controls whether or not the dns.additionals field" >> /etc/packetbeat/packetbeat.yml
echo "  # (additional resource records) is added to messages." >> /etc/packetbeat/packetbeat.yml
echo "  include_additionals: true" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: http" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the ports where to listen for HTTP traffic. You can disable" >> /etc/packetbeat/packetbeat.yml
echo "  # the HTTP protocol by commenting out the list of ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [80, 8080, 8000, 5000, 8002]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: memcache" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the ports where to listen for memcache traffic. You can disable" >> /etc/packetbeat/packetbeat.yml
echo "  # the Memcache protocol by commenting out the list of ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [11211]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: mysql" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the ports where to listen for MySQL traffic. You can disable" >> /etc/packetbeat/packetbeat.yml
echo "  # the MySQL protocol by commenting out the list of ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [3306]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: pgsql" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the ports where to listen for Pgsql traffic. You can disable" >> /etc/packetbeat/packetbeat.yml
echo "  # the Pgsql protocol by commenting out the list of ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [5432]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: redis" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the ports where to listen for Redis traffic. You can disable" >> /etc/packetbeat/packetbeat.yml
echo "  # the Redis protocol by commenting out the list of ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [6379]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: thrift" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the ports where to listen for Thrift-RPC traffic. You can disable" >> /etc/packetbeat/packetbeat.yml
echo "  # the Thrift-RPC protocol by commenting out the list of ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [9090]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: mongodb" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the ports where to listen for MongoDB traffic. You can disable" >> /etc/packetbeat/packetbeat.yml
echo "  # the MongoDB protocol by commenting out the list of ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [27017]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: nfs" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the ports where to listen for NFS traffic. You can disable" >> /etc/packetbeat/packetbeat.yml
echo "  # the NFS protocol by commenting out the list of ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [2049]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "- type: tls" >> /etc/packetbeat/packetbeat.yml
echo "  # Configure the ports where to listen for TLS traffic. You can disable" >> /etc/packetbeat/packetbeat.yml
echo "  # the TLS protocol by commenting out the list of ports." >> /etc/packetbeat/packetbeat.yml
echo "  ports: [443]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#==================== Elasticsearch template setting ==========================" >> /etc/packetbeat/packetbeat.yml
echo "setup.template.settings:" >> /etc/packetbeat/packetbeat.yml
echo "  index.number_of_shards: 3" >> /etc/packetbeat/packetbeat.yml
echo "  #index.codec: best_compression" >> /etc/packetbeat/packetbeat.yml
echo "  #_source.enabled: false" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#================================ General =====================================" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# The name of the shipper that publishes the network data. It can be used to group" >> /etc/packetbeat/packetbeat.yml
echo "# all the transactions sent by a single shipper in the web interface." >> /etc/packetbeat/packetbeat.yml
echo "#name:" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# The tags of the shipper are included in their own field with each" >> /etc/packetbeat/packetbeat.yml
echo "# transaction published." >> /etc/packetbeat/packetbeat.yml
echo "#tags: [\"service-X\", \"web-tier\"]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# Optional fields that you can specify to add additional information to the" >> /etc/packetbeat/packetbeat.yml
echo "# output." >> /etc/packetbeat/packetbeat.yml
echo "#fields:" >> /etc/packetbeat/packetbeat.yml
echo "#  env: staging" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#============================== Dashboards =====================================" >> /etc/packetbeat/packetbeat.yml
echo "# These settings control loading the sample dashboards to the Kibana index. Loading" >> /etc/packetbeat/packetbeat.yml
echo "# the dashboards is disabled by default and can be enabled either by setting the" >> /etc/packetbeat/packetbeat.yml
echo "# options here, or by using the \`-setup\` CLI flag or the \`setup\` command." >> /etc/packetbeat/packetbeat.yml
echo "#setup.dashboards.enabled: false" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# The URL from where to download the dashboards archive. By default this URL" >> /etc/packetbeat/packetbeat.yml
echo "# has a value which is computed based on the Beat name and version. For released" >> /etc/packetbeat/packetbeat.yml
echo "# versions, this URL points to the dashboard archive on the artifacts.elastic.co" >> /etc/packetbeat/packetbeat.yml
echo "# website." >> /etc/packetbeat/packetbeat.yml
echo "#setup.dashboards.url:" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#============================== Kibana =====================================" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API." >> /etc/packetbeat/packetbeat.yml
echo "# This requires a Kibana endpoint configuration." >> /etc/packetbeat/packetbeat.yml
echo "setup.kibana:" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "  # Kibana Host" >> /etc/packetbeat/packetbeat.yml
echo "  # Scheme and port can be left out and will be set to the default (http and 5601)" >> /etc/packetbeat/packetbeat.yml
echo "  # In case you specify and additional path, the scheme is required: http://localhost:5601/path" >> /etc/packetbeat/packetbeat.yml
echo "  # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601" >> /etc/packetbeat/packetbeat.yml
echo "  host: \"https://app.vizion.ai:443\"" >> /etc/packetbeat/packetbeat.yml
echo "  protocol: \"https\"" >> /etc/packetbeat/packetbeat.yml
echo "  username: \"${USERNAME}\"" >> /etc/packetbeat/packetbeat.yml
echo "  password: \"${PASSWORD}\"" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "  # Kibana Space ID" >> /etc/packetbeat/packetbeat.yml
echo "  # ID of the Kibana Space into which the dashboards should be loaded. By default," >> /etc/packetbeat/packetbeat.yml
echo "  # the Default Space will be used." >> /etc/packetbeat/packetbeat.yml
echo "  #space.id:" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#============================= Elastic Cloud ==================================" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# These settings simplify using packetbeat with the Elastic Cloud (https://cloud.elastic.co/)." >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# The cloud.id setting overwrites the \`output.elasticsearch.hosts\` and" >> /etc/packetbeat/packetbeat.yml
echo "# \`setup.kibana.host\` options." >> /etc/packetbeat/packetbeat.yml
echo "# You can find the \`cloud.id\` in the Elastic Cloud web UI." >> /etc/packetbeat/packetbeat.yml
echo "#cloud.id:" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# The cloud.auth setting overwrites the \`output.elasticsearch.username\` and" >> /etc/packetbeat/packetbeat.yml
echo "# \`output.elasticsearch.password\` settings. The format is \`<user>:<pass>\`." >> /etc/packetbeat/packetbeat.yml
echo "#cloud.auth:" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#================================ Outputs =====================================" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# Configure what output to use when sending the data collected by the beat." >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#-------------------------- Elasticsearch output ------------------------------" >> /etc/packetbeat/packetbeat.yml
echo "output.elasticsearch:" >> /etc/packetbeat/packetbeat.yml
echo "  # Array of hosts to connect to." >> /etc/packetbeat/packetbeat.yml
echo "  hosts: [\"$1:443\"]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "  # Optional protocol and basic auth credentials." >> /etc/packetbeat/packetbeat.yml
echo "  #protocol: \"https\"" >> /etc/packetbeat/packetbeat.yml
echo "  username: \"${USERNAME}\"" >> /etc/packetbeat/packetbeat.yml
echo "  password: \"${PASSWORD}\"" >> /etc/packetbeat/packetbeat.yml
echo "  ssl.verification_mode: none" >> /etc/packetbeat/packetbeat.yml
echo "  headers:" >> /etc/packetbeat/packetbeat.yml
echo "    vizion-es-app-id: ${API_KEY}" >> /etc/packetbeat/packetbeat.yml
echo "  timeout: 500" >> /etc/packetbeat/packetbeat.yml
echo "#----------------------------- Logstash output --------------------------------" >> /etc/packetbeat/packetbeat.yml
echo "#output.logstash:" >> /etc/packetbeat/packetbeat.yml
echo "  # The Logstash hosts" >> /etc/packetbeat/packetbeat.yml
echo "  #hosts: [\"localhost:5044\"]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "  # Optional SSL. By default is off." >> /etc/packetbeat/packetbeat.yml
echo "  # List of root certificates for HTTPS server verifications" >> /etc/packetbeat/packetbeat.yml
echo "  #ssl.certificate_authorities: [\"/etc/pki/root/ca.pem\"]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "  # Certificate for SSL client authentication" >> /etc/packetbeat/packetbeat.yml
echo "  #ssl.certificate: \"/etc/pki/client/cert.pem\"" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "  # Client Certificate Key" >> /etc/packetbeat/packetbeat.yml
echo "  #ssl.key: \"/etc/pki/client/cert.key\"" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#================================ Procesors =====================================" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# Configure processors to enhance or manipulate events generated by the beat." >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "processors:" >> /etc/packetbeat/packetbeat.yml
echo "  - add_host_metadata: ~" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#================================ Logging =====================================" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# Sets log level. The default log level is info." >> /etc/packetbeat/packetbeat.yml
echo "# Available log levels are: error, warning, info, debug" >> /etc/packetbeat/packetbeat.yml
echo "#logging.level: debug" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# At debug level, you can selectively enable logging only for some components." >> /etc/packetbeat/packetbeat.yml
echo "# To enable all selectors use [\"*\"]. Examples of other selectors are \"beat\"," >> /etc/packetbeat/packetbeat.yml
echo "# \"publish\", \"service\"." >> /etc/packetbeat/packetbeat.yml
echo "#logging.selectors: [\"*\"]" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "#============================== Xpack Monitoring ===============================" >> /etc/packetbeat/packetbeat.yml
echo "# packetbeat can export internal metrics to a central Elasticsearch monitoring" >> /etc/packetbeat/packetbeat.yml
echo "# cluster.  This requires xpack monitoring to be enabled in Elasticsearch.  The" >> /etc/packetbeat/packetbeat.yml
echo "# reporting is disabled by default." >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# Set to true to enable the monitoring reporter." >> /etc/packetbeat/packetbeat.yml
echo "#xpack.monitoring.enabled: false" >> /etc/packetbeat/packetbeat.yml
echo "" >> /etc/packetbeat/packetbeat.yml
echo "# Uncomment to send the metrics to Elasticsearch. Most settings from the" >> /etc/packetbeat/packetbeat.yml
echo "# Elasticsearch output are accepted here as well. Any setting that is not set is" >> /etc/packetbeat/packetbeat.yml
echo "# automatically inherited from the Elasticsearch output configuration, so if you" >> /etc/packetbeat/packetbeat.yml
echo "# have the Elasticsearch output configured, you can simply uncomment the" >> /etc/packetbeat/packetbeat.yml
echo "# following line." >> /etc/packetbeat/packetbeat.yml
echo "#xpack.monitoring.elasticsearch:" >> /etc/packetbeat/packetbeat.yml


if [[ $DOWNLOAD_TYPE -le 2 ]]; then #deb or rpm
  packetbeat setup --template
  sudo service packetbeat start
else
  ./packetbeat setup --template
  sudo chown root packetbeat.yml
  sudo ./packetbeat -e
fi