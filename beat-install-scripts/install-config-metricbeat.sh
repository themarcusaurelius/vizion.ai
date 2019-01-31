#! /bin/bash
echo
echo
echo "What type of download for your system?"
echo "Enter (1)for Debian, (2)for rpm, (3)for mac, (4)for tar/linux"
read DOWNLOAD_TYPE

if [[ $DOWNLOAD_TYPE -eq 1 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.5.4-amd64.deb
  sudo dpkg -i metricbeat-6.5.4-amd64.deb
elif [[ $DOWNLOAD_TYPE -eq 2 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.5.4-x86_64.rpm
  sudo rpm -vi metricbeat-6.5.4-x86_64.rpm
elif [[ $DOWNLOAD_TYPE -eq 3 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.5.4-darwin-x86_64.tar.gz
  tar xzvf metricbeat-6.5.4-darwin-x86_64.tar.gz
elif [[ $DOWNLOAD_TYPE -eq 4 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.5.4-linux-x86_64.tar.gz
  tar xzvf metricbeat-6.5.4-linux-x86_64.tar.gz
else
  echo "That was not one of the options. Exiting."
  exit 1
fi

USERNAME_REGEX="https://([a-zA-Z0-9]*):"
PASSWORD_REGEX=":([a-zA-Z0-9]*)@"

if [[ $1 =~ $USERNAME_REGEX ]]; then
  USERNAME=${BASH_REMATCH[1]}
else
  echo "URL could not be  (username part). Please be sure to include full URL"
  exit 1
fi

if [[ $1 =~ $PASSWORD_REGEX ]]; then
  PASSWORD=${BASH_REMATCH[1]}
else
  echo "URL could not be parsed (password part). Please be sure to include full URL"
  exit 1
fi

echo "###################### Metricbeat Configuration Example #######################" > /etc/metricbeat/metricbeat.yml 
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# This file is an example configuration file highlighting only the most common/etc/metricbeat/metricbeat.yml" >> /etc/metricbeat/metricbeat.yml
echo "# options. The metricbeat.reference.yml file from the same directory contains all the" >> /etc/metricbeat/metricbeat.yml
echo "# supported options with more comments. You can use it as a reference." >> /etc/metricbeat/metricbeat.yml
echo "#" >> /etc/metricbeat/metricbeat.yml
echo "# You can find the full configuration reference here:" >> /etc/metricbeat/metricbeat.yml
echo "# https://www.elastic.co/guide/en/beats/metricbeat/index.html" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#==========================  Modules configuration ============================" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "metricbeat.config.modules:" >> /etc/metricbeat/metricbeat.yml
echo "  # Glob pattern for configuration loading" >> /etc/metricbeat/metricbeat.yml
echo "  path: \${path.config}/modules.d/*.yml" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "  # Set to true to enable config reloading" >> /etc/metricbeat/metricbeat.yml
echo "  reload.enabled: false" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "  # Period on which files under path should be checked for changes" >> /etc/metricbeat/metricbeat.yml
echo "  #reload.period: 10s" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#==================== Elasticsearch template setting ==========================" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "setup.template.settings:" >> /etc/metricbeat/metricbeat.yml
echo "  index.number_of_shards: 1" >> /etc/metricbeat/metricbeat.yml
echo "  index.codec: best_compression" >> /etc/metricbeat/metricbeat.yml
echo "  #_source.enabled: false" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#================================ General =====================================" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# The name of the shipper that publishes the network data. It can be used to group" >> /etc/metricbeat/metricbeat.yml
echo "# all the transactions sent by a single shipper in the web interface." >> /etc/metricbeat/metricbeat.yml
echo "#name:" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# The tags of the shipper are included in their own field with each" >> /etc/metricbeat/metricbeat.yml
echo "# transaction published." >> /etc/metricbeat/metricbeat.yml
echo "#tags: [\"service-X\", \"web-tier\"]" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# Optional fields that you can specify to add additional information to the" >> /etc/metricbeat/metricbeat.yml
echo "# output." >> /etc/metricbeat/metricbeat.yml
echo "#fields:" >> /etc/metricbeat/metricbeat.yml
echo "#  env: staging" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#============================== Dashboards =====================================" >> /etc/metricbeat/metricbeat.yml
echo "# These settings control loading the sample dashboards to the Kibana index. Loading" >> /etc/metricbeat/metricbeat.yml
echo "# the dashboards is disabled by default and can be enabled either by setting the" >> /etc/metricbeat/metricbeat.yml
echo "# options here, or by using the \`-setup\` CLI flag or the \`setup\` command." >> /etc/metricbeat/metricbeat.yml
echo "#setup.dashboards.enabled: true" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# The URL from where to download the dashboards archive. By default this URL" >> /etc/metricbeat/metricbeat.yml
echo "# has a value which is computed based on the Beat name and version. For released" >> /etc/metricbeat/metricbeat.yml
echo "# versions, this URL points to the dashboard archive on the artifacts.elastic.co" >> /etc/metricbeat/metricbeat.yml
echo "# website." >> /etc/metricbeat/metricbeat.yml
echo "#setup.dashboards.url:" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#============================== Kibana =====================================" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API." >> /etc/metricbeat/metricbeat.yml
echo "# This requires a Kibana endpoint configuration." >> /etc/metricbeat/metricbeat.yml
echo "setup.kibana:" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "  # Kibana Host" >> /etc/metricbeat/metricbeat.yml
echo "  # Scheme and port can be left out and will be set to the default (http and 5601)" >> /etc/metricbeat/metricbeat.yml
echo "  # In case you specify and additional path, the scheme is required: echo http://localhost:5601/path" >> /etc/metricbeat/metricbeat.yml
echo "  # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601" >> /etc/metricbeat/metricbeat.yml
echo "  host: \"https://app.vizion.ai:443/kibana\"" >> /etc/metricbeat/metricbeat.yml
echo "  username: \"${USERNAME}\"" >> /etc/metricbeat/metricbeat.yml
echo "  password: \"${PASSWORD}\"" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "  # Kibana Space ID" >> /etc/metricbeat/metricbeat.yml
echo "  # ID of the Kibana Space into which the dashboards should be loaded. By default," >> /etc/metricbeat/metricbeat.yml
echo "  # the Default Space will be used." >> /etc/metricbeat/metricbeat.yml
echo "  #space.id:" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#============================= Elastic Cloud ==================================" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# These settings simplify using metricbeat with the Elastic Cloud(https://cloud.elastic.co/)." >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# The cloud.id setting overwrites the `output.elasticsearch.hosts` and" >> /etc/metricbeat/metricbeat.yml
echo "# `setup.kibana.host` options." >> /etc/metricbeat/metricbeat.yml
echo "# You can find the `cloud.id` in the Elastic Cloud web UI." >> /etc/metricbeat/metricbeat.yml
echo "#cloud.id:" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# The cloud.auth setting overwrites the `output.elasticsearch.username` and" >> /etc/metricbeat/metricbeat.yml
echo "# `output.elasticsearch.password` settings. The format is `<user>:<pass>`." >> /etc/metricbeat/metricbeat.yml
echo "#cloud.auth:" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#================================ Outputs =====================================" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# Configure what output to use when sending the data collected by the beat." >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#-------------------------- Elasticsearch output ------------------------------" >> /etc/metricbeat/metricbeat.yml
echo "output.elasticsearch:" >> /etc/metricbeat/metricbeat.yml
echo "  # Array of hosts to connect to." >> /etc/metricbeat/metricbeat.yml
echo "  hosts: [\"$1\"]" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "  # Optional protocol and basic auth credentials." >> /etc/metricbeat/metricbeat.yml
echo "  protocol: \"https\"" >> /etc/metricbeat/metricbeat.yml
echo "  username: \"${USERNAME}\"" >> /etc/metricbeat/metricbeat.yml
echo "  password: \"${PASSWORD}\"" >> /etc/metricbeat/metricbeat.yml
echo "  ssl.enabled: true" >> /etc/metricbeat/metricbeat.yml
echo "  ssl.verification_mode: none" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#----------------------------- Logstash output --------------------------------" >> /etc/metricbeat/metricbeat.yml
echo "#output.logstash:" >> /etc/metricbeat/metricbeat.yml
echo "  # The Logstash hosts" >> /etc/metricbeat/metricbeat.yml
echo "  #hosts: [\"localhost:5044\"]" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "  # Optional SSL. By default is off." >> /etc/metricbeat/metricbeat.yml
echo "  # List of root certificates for HTTPS server verifications" >> /etc/metricbeat/metricbeat.yml
echo "  #ssl.certificate_authorities: [\"/etc/pki/root/ca.pem\"]" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "  # Certificate for SSL client authentication" >> /etc/metricbeat/metricbeat.yml
echo "  #ssl.certificate: \"/etc/pki/client/cert.pem\"" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "  # Client Certificate Key" >> /etc/metricbeat/metricbeat.yml
echo "  #ssl.key: \"/etc/pki/client/cert.key\"" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#================================ Procesors =====================================" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# Configure processors to enhance or manipulate events generated by the beat." >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "processors:" >> /etc/metricbeat/metricbeat.yml
echo "  - add_host_metadata: ~" >> /etc/metricbeat/metricbeat.yml
echo "  - add_cloud_metadata: ~" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#================================ Logging =====================================" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# Sets log level. The default log level is info." >> /etc/metricbeat/metricbeat.yml
echo "# Available log levels are: error, warning, info, debug" >> /etc/metricbeat/metricbeat.yml
echo "#logging.level: debug" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# At debug level, you can selectively enable logging only for some components." >> /etc/metricbeat/metricbeat.yml
echo "# To enable all selectors use [\"*\"]. Examples of other selectors are \"beat\"," >> /etc/metricbeat/metricbeat.yml
echo "# \"publish\", \"service\"." >> /etc/metricbeat/metricbeat.yml
echo "#logging.selectors: [\"*\"]" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "#============================== Xpack Monitoring ===============================" >> /etc/metricbeat/metricbeat.yml
echo "# metricbeat can export internal metrics to a central Elasticsearch monitoring" >> /etc/metricbeat/metricbeat.yml
echo "# cluster.  This requires xpack monitoring to be enabled in Elasticsearch.  The" >> /etc/metricbeat/metricbeat.yml
echo "# reporting is disabled by default." >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# Set to true to enable the monitoring reporter." >> /etc/metricbeat/metricbeat.yml
echo "#xpack.monitoring.enabled: false" >> /etc/metricbeat/metricbeat.yml
echo "" >> /etc/metricbeat/metricbeat.yml
echo "# Uncomment to send the metrics to Elasticsearch. Most settings from the" >> /etc/metricbeat/metricbeat.yml
echo "# Elasticsearch output are accepted here as well. Any setting that is not set is" >> /etc/metricbeat/metricbeat.yml
echo "# automatically inherited from the Elasticsearch output configuration, so if you" >> /etc/metricbeat/metricbeat.yml
echo "# have the Elasticsearch output configured, you can simply uncomment the" >> /etc/metricbeat/metricbeat.yml
echo "# following line." >> /etc/metricbeat/metricbeat.yml
echo "#xpack.monitoring.elasticsearch:" >> /etc/metricbeat/metricbeat.yml

if [[ $DOWNLOAD_TYPE -le 2 ]]; then #deb or rpm
  metricbeat setup --template
  sudo service metricbeat start
else
  ./metricbeat setup --template
  sudo chown root metricbeat.yml 
  sudo chown root modules.d/system.yml 
  sudo ./metricbeat -e
fi