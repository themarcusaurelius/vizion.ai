#! /bin/bash
echo
echo
echo "What type of download for your system?"
echo "Enter (1)for Debian, (2)for rpm, (3)for mac, (4)for tar/linux"
read DOWNLOAD_TYPE

if [[ $DOWNLOAD_TYPE -eq 1 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-6.5.4-amd64.deb
  sudo dpkg -i heartbeat-6.5.4-amd64.deb
elif [[ $DOWNLOAD_TYPE -eq 2 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-6.5.4-x86_64.rpm
  sudo rpm -vi heartbeat-6.5.4-x86_64.rpm
elif [[ $DOWNLOAD_TYPE -eq 3 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-6.5.4-darwin-x86_64.tar.gz
  tar xzvf heartbeat-6.5.4-darwin-x86_64.tar.gz
elif [[ $DOWNLOAD_TYPE -eq 4 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-6.5.4-linux-x86_64.tar.gz
  tar xzvf heartbeat-6.5.4-linux-x86_64.tar.gz
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

echo "############################# Heartbeat ######################################" > /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# Configure monitors" >> /etc/heartbeat/heartbeat.yml
echo "heartbeat.monitors:" >> /etc/heartbeat/heartbeat.yml
echo "- type: http" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "  # List or urls to query" >> /etc/heartbeat/heartbeat.yml
echo "  urls: [\"<< your url to monitor here >>\"]" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "  # Configure task schedule" >> /etc/heartbeat/heartbeat.yml
echo "  schedule: \'@every 10s\'" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "  # Total test connection and data exchange timeout" >> /etc/heartbeat/heartbeat.yml
echo "  #timeout: 16s" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "#==================== Elasticsearch template setting ==========================" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "setup.template.settings:" >> /etc/heartbeat/heartbeat.yml
echo "  index.number_of_shards: 1" >> /etc/heartbeat/heartbeat.yml
echo "  index.codec: best_compression" >> /etc/heartbeat/heartbeat.yml
echo "  #_source.enabled: false" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "#================================ General =====================================" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# The name of the shipper that publishes the network data. It can be used to group" >> /etc/heartbeat/heartbeat.yml
echo "# all the transactions sent by a single shipper in the web interface." >> /etc/heartbeat/heartbeat.yml
echo "#name:" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# The tags of the shipper are included in their own field with each" >> /etc/heartbeat/heartbeat.yml
echo "# transaction published." >> /etc/heartbeat/heartbeat.yml
echo "#tags: [\"service-X\", \"web-tier\"]" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# Optional fields that you can specify to add additional information to the" >> /etc/heartbeat/heartbeat.yml
echo "# output." >> /etc/heartbeat/heartbeat.yml
echo "#fields:" >> /etc/heartbeat/heartbeat.yml
echo "#  env: staging" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "#============================== Dashboards =====================================" >> /etc/heartbeat/heartbeat.yml
echo "# These settings control loading the sample dashboards to the Kibana index. Loading" >> /etc/heartbeat/heartbeat.yml
echo "# the dashboards is disabled by default and can be enabled either by setting the" >> /etc/heartbeat/heartbeat.yml
echo "# options here, or by using the \`-setup\` CLI flag or the \`setup\` command." >> /etc/heartbeat/heartbeat.yml
echo "#setup.dashboards.enabled: false" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# The URL from where to download the dashboards archive. By default this URL" >> /etc/heartbeat/heartbeat.yml
echo "# has a value which is computed based on the Beat name and version. For released" >> /etc/heartbeat/heartbeat.yml
echo "# versions, this URL points to the dashboard archive on the artifacts.elastic.co" >> /etc/heartbeat/heartbeat.yml
echo "# website." >> /etc/heartbeat/heartbeat.yml
echo "#setup.dashboards.url:" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "#============================== Kibana =====================================" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API." >> /etc/heartbeat/heartbeat.yml
echo "# This requires a Kibana endpoint configuration." >> /etc/heartbeat/heartbeat.yml
echo "setup.kibana:" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "  # Kibana Host" >> /etc/heartbeat/heartbeat.yml
echo "  # Scheme and port can be left out and will be set to the default (http and 5601)" >> /etc/heartbeat/heartbeat.yml
echo "  # In case you specify and additional path, the scheme is required: http://localhost:5601/path" >> /etc/heartbeat/heartbeat.yml
echo "  # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601" >> /etc/heartbeat/heartbeat.yml
echo "  host: \"https://app.vizion.ai:443\"" >> /etc/heartbeat/heartbeat.yml
echo "  protocol: \"https\"" >> /etc/heartbeat/heartbeat.yml
echo "  username: "${USERNAME}"" >> /etc/heartbeat/heartbeat.yml
echo "  password: "${PASSWORD}"" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "  # Kibana Space ID" >> /etc/heartbeat/heartbeat.yml
echo "  # ID of the Kibana Space into which the dashboards should be loaded. By default," >> /etc/heartbeat/heartbeat.yml
echo "  # the Default Space will be used." >> /etc/heartbeat/heartbeat.yml
echo "  #space.id:" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "#============================= Elastic Cloud ==================================" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# These settings simplify using heartbeat with the Elastic Cloud (https://cloud.elastic.co/)." >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# The cloud.id setting overwrites the \`output.elasticsearch.hosts\` and" >> /etc/heartbeat/heartbeat.yml
echo "# \`setup.kibana.host\` options." >> /etc/heartbeat/heartbeat.yml
echo "# You can find the \`cloud.id\` in the Elastic Cloud web UI." >> /etc/heartbeat/heartbeat.yml
echo "#cloud.id:" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# The cloud.auth setting overwrites the \`output.elasticsearch.username\` and" >> /etc/heartbeat/heartbeat.yml
echo "# \`output.elasticsearch.password\` settings. The format is \`<user>:<pass>\`." >> /etc/heartbeat/heartbeat.yml
echo "#cloud.auth:" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "#================================ Outputs =====================================" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# Configure what output to use when sending the data collected by the beat." >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "#-------------------------- Elasticsearch output ------------------------------" >> /etc/heartbeat/heartbeat.yml
echo "output.elasticsearch:" >> /etc/heartbeat/heartbeat.yml
echo "  # Array of hosts to connect to." >> /etc/heartbeat/heartbeat.yml
echo "  hosts: [\"$1:443\"]" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "  # Optional protocol and basic auth credentials." >> /etc/heartbeat/heartbeat.yml
echo "  #protocol: \"https\"" >> /etc/heartbeat/heartbeat.yml
echo "  username: \"${USERNAME}\"" >> /etc/heartbeat/heartbeat.yml
echo "  passowrd: \"${PASSWORD}\"" >> /etc/heartbeat/heartbeat.yml
echo "  ssl.verification_mode: none" >> /etc/heartbeat/heartbeat.yml
echo "  headers:" >> /etc/heartbeat/heartbeat.yml
echo "    vizion-es-app-id: ${API_KEY}" >> /etc/heartbeat/heartbeat.yml
echo "  timeout: 500" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "#----------------------------- Logstash output --------------------------------" >> /etc/heartbeat/heartbeat.yml
echo "#output.logstash:" >> /etc/heartbeat/heartbeat.yml
echo "  # The Logstash hosts" >> /etc/heartbeat/heartbeat.yml
echo "  #hosts: [\"localhost:5044\"]" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "  # Optional SSL. By default is off." >> /etc/heartbeat/heartbeat.yml
echo "  # List of root certificates for HTTPS server verifications" >> /etc/heartbeat/heartbeat.yml
echo "  #ssl.certificate_authorities: [\"/etc/pki/root/ca.pem\"]" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "  # Certificate for SSL client authentication" >> /etc/heartbeat/heartbeat.yml
echo "  #ssl.certificate: "/etc/pki/client/cert.pem"" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "  # Client Certificate Key" >> /etc/heartbeat/heartbeat.yml
echo "  #ssl.key: \"/etc/pki/client/cert.key\"" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "#================================ Procesors =====================================" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# Configure processors to enhance or manipulate events generated by the beat." >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "processors:" >> /etc/heartbeat/heartbeat.yml
echo "  - add_host_metadata: ~" >> /etc/heartbeat/heartbeat.yml
echo "  - add_cloud_metadata: ~" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "#================================ Logging =====================================" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# Sets log level. The default log level is info." >> /etc/heartbeat/heartbeat.yml
echo "# Available log levels are: error, warning, info, debug" >> /etc/heartbeat/heartbeat.yml
echo "#logging.level: debug" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# At debug level, you can selectively enable logging only for some components." >> /etc/heartbeat/heartbeat.yml
echo "# To enable all selectors use [\"*\"]. Examples of other selectors are \"beat\"," >> /etc/heartbeat/heartbeat.yml
echo "# \"publish\", \"service\"." >> /etc/heartbeat/heartbeat.yml
echo "#logging.selectors: [\"*\"]" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "#============================== Xpack Monitoring ===============================" >> /etc/heartbeat/heartbeat.yml
echo "# heartbeat can export internal metrics to a central Elasticsearch monitoring" >> /etc/heartbeat/heartbeat.yml
echo "# cluster.  This requires xpack monitoring to be enabled in Elasticsearch.  The" >> /etc/heartbeat/heartbeat.yml
echo "# reporting is disabled by default." >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# Set to true to enable the monitoring reporter." >> /etc/heartbeat/heartbeat.yml
echo "#xpack.monitoring.enabled: false" >> /etc/heartbeat/heartbeat.yml
echo "" >> /etc/heartbeat/heartbeat.yml
echo "# Uncomment to send the metrics to Elasticsearch. Most settings from the" >> /etc/heartbeat/heartbeat.yml
echo "# Elasticsearch output are accepted here as well. Any setting that is not set is" >> /etc/heartbeat/heartbeat.yml
echo "# automatically inherited from the Elasticsearch output configuration, so if you" >> /etc/heartbeat/heartbeat.yml
echo "# have the Elasticsearch output configured, you can simply uncomment the" >> /etc/heartbeat/heartbeat.yml
echo "# following line." >> /etc/heartbeat/heartbeat.yml
echo "#xpack.monitoring.elasticsearch:" >> /etc/heartbeat/heartbeat.yml

if [[ $DOWNLOAD_TYPE -le 2 ]]; then #deb or rpm
  heartbeat setup --template
  sudo service heartbeat-elastic start
else
  ./heartbeat setup --template
  sudo chown root heartbeat.yml
  sudo ./heartbeat -e
fi