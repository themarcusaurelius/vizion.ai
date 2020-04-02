#! /bin/bash
echo
echo
echo "What type of download for your system?"
echo "Enter (1)for Debian, (2)for rpm, (3)for mac, (4)for tar/linux"
read DOWNLOAD_TYPE

if [[ $DOWNLOAD_TYPE -eq 1 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-amd64.deb
  sudo dpkg -i filebeat-6.5.4-amd64.deb
elif [[ $DOWNLOAD_TYPE -eq 2 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-x86_64.rpm
  sudo rpm -vi filebeat-6.5.4-x86_64.rpm
elif [[ $DOWNLOAD_TYPE -eq 3 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-darwin-x86_64.tar.gz
  sudo tar -xvf filebeat-6.5.4-darwin-x86_64.tar.gz -C /etc
  mv /etc/filebeat-6.5.4-darwin-x86_64 /etc/filebeat
elif [[ $DOWNLOAD_TYPE -eq 4 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-linux-x86_64.tar.gz
  tar xzvf filebeat-6.5.4-linux-x86_64.tar.gz
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

echo "###################### Filebeat Configuration Example #########################" > /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# This file is an example configuration file highlighting only the most common" >> /etc/filebeat/filebeat.yml
echo "# options. The filebeat.reference.yml file from the same directory contains all the" >> /etc/filebeat/filebeat.yml
echo "# supported options with more comments. You can use it as a reference." >> /etc/filebeat/filebeat.yml
echo "#" >> /etc/filebeat/filebeat.yml
echo "# You can find the full configuration reference here:" >> /etc/filebeat/filebeat.yml
echo "# https://www.elastic.co/guide/en/beats/filebeat/index.html" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# For more available modules and options, please see the filebeat.reference.yml sample" >> /etc/filebeat/filebeat.yml
echo "# configuration file." >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#=========================== Filebeat inputs =============================" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "filebeat.inputs:" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# Each - is an input. Most options can be set at the input level, so" >> /etc/filebeat/filebeat.yml
echo "# you can use different inputs for various configurations." >> /etc/filebeat/filebeat.yml
echo "# Below are the input specific configurations." >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "- type: log" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Change to true to enable this input configuration." >> /etc/filebeat/filebeat.yml
echo "  enabled: true" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Paths that should be crawled and fetched. Glob based paths." >> /etc/filebeat/filebeat.yml
echo "  paths:" >> /etc/filebeat/filebeat.yml
echo "    - /var/log/*/*" >> /etc/filebeat/filebeat.yml
echo "    #- c:\programdata\elasticsearch\logs\*" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Exclude lines. A list of regular expressions to match. It drops the lines that are" >> /etc/filebeat/filebeat.yml
echo "  # matching any regular expression from the list. By default, no files are dropped." >> /etc/filebeat/filebeat.yml
echo "  #exclude_files: ['.gz$']" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Optional additional fields. These fields can be freely picked" >> /etc/filebeat/filebeat.yml
echo "  # to add additional information to the crawled log files for filtering" >> /etc/filebeat/filebeat.yml
echo "  #fields:" >> /etc/filebeat/filebeat.yml
echo "  #  level: debug" >> /etc/filebeat/filebeat.yml
echo "  #  review: 1" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  ### Multiline options" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Multiline can be used for log messages spanning multiple lines. This is common" >> /etc/filebeat/filebeat.yml
echo "  # for Java Stack Traces or C-Line Continuation" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # The regexp Pattern that has to be matched. The example pattern matches all lines starting with [" >> /etc/filebeat/filebeat.yml
echo "  #multiline.pattern: ^\[" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Defines if the pattern set under pattern should be negated or not. Default is false." >> /etc/filebeat/filebeat.yml
echo "  #multiline.negate: false" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Match can be set to \"after\" or \"before\". It is used to define if lines should be append to a pattern" >> /etc/filebeat/filebeat.yml
echo "  # that was (not) matched before or after or as long as a pattern is not matched based on negate." >> /etc/filebeat/filebeat.yml
echo "  # Note: After is the equivalent to previous and before is the equivalent to to next in Logstash" >> /etc/filebeat/filebeat.yml
echo "  #multiline.match: after" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#============================= Filebeat modules ===============================" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "filebeat.config.modules:" >> /etc/filebeat/filebeat.yml
echo "  # Glob pattern for configuration loading" >> /etc/filebeat/filebeat.yml
echo "  path: \${path.config}/modules.d/*.yml" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Set to true to enable config reloading" >> /etc/filebeat/filebeat.yml
echo "  reload.enabled: false" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Period on which files under path should be checked for changes" >> /etc/filebeat/filebeat.yml
echo "  #reload.period: 10s" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#==================== Elasticsearch template setting ==========================" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "setup.template.settings:" >> /etc/filebeat/filebeat.yml
echo "  index.number_of_shards: 3" >> /etc/filebeat/filebeat.yml
echo "  #index.codec: best_compression" >> /etc/filebeat/filebeat.yml
echo "  #_source.enabled: false" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#================================ General =====================================" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# The name of the shipper that publishes the network data. It can be used to group" >> /etc/filebeat/filebeat.yml
echo "# all the transactions sent by a single shipper in the web interface." >> /etc/filebeat/filebeat.yml
echo "#name:" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# The tags of the shipper are included in their own field with each" >> /etc/filebeat/filebeat.yml
echo "# transaction published." >> /etc/filebeat/filebeat.yml
echo "#tags: [\"service-X\", \"web-tier\"]" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# Optional fields that you can specify to add additional information to the" >> /etc/filebeat/filebeat.yml
echo "# output." >> /etc/filebeat/filebeat.yml
echo "#fields:" >> /etc/filebeat/filebeat.yml
echo "#  env: staging" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#============================== Dashboards =====================================" >> /etc/filebeat/filebeat.yml
echo "# These settings control loading the sample dashboards to the Kibana index. Loading" >> /etc/filebeat/filebeat.yml
echo "# the dashboards is disabled by default and can be enabled either by setting the" >> /etc/filebeat/filebeat.yml
echo "# options here, or by using the \`-setup\` CLI flag or the \`setup\` command." >> /etc/filebeat/filebeat.yml
echo "#setup.dashboards.enabled: false" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# The URL from where to download the dashboards archive. By default this URL" >> /etc/filebeat/filebeat.yml
echo "# has a value which is computed based on the Beat name and version. For released" >> /etc/filebeat/filebeat.yml
echo "# versions, this URL points to the dashboard archive on the artifacts.elastic.co" >> /etc/filebeat/filebeat.yml
echo "# website." >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#setup.dashboards.url:" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#============================== Kibana =====================================" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API." >> /etc/filebeat/filebeat.yml
echo "# This requires a Kibana endpoint configuration." >> /etc/filebeat/filebeat.yml
echo "setup.kibana:" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Kibana Host" >> /etc/filebeat/filebeat.yml
echo "  # Scheme and port can be left out and will be set to the default (http and 5601)" >> /etc/filebeat/filebeat.yml
echo "  # In case you specify and additional path, the scheme is required: http://localhost:5601/path" >> /etc/filebeat/filebeat.yml
echo "  # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601" >> /etc/filebeat/filebeat.yml
echo "  host: \"https://app.vizion.ai:443/kibana\"" >> /etc/filebeat/filebeat.yml
echo "  username: \"${USERNAME}\"" >> /etc/filebeat/filebeat.yml
echo "  password: \"${PASSWORD}\"" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Kibana Space ID" >> /etc/filebeat/filebeat.yml
echo "  # ID of the Kibana Space into which the dashboards should be loaded. By default," >> /etc/filebeat/filebeat.yml
echo "  # the Default Space will be used." >> /etc/filebeat/filebeat.yml
echo "  #space.id:" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#============================= Elastic Cloud ==================================" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# These settings simplify using filebeat with the Elastic Cloud (https://cloud.elastic.co/)." >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# The cloud.id setting overwrites the \`output.elasticsearch.hosts\` and" >> /etc/filebeat/filebeat.yml
echo "# \`setup.kibana.host\` options." >> /etc/filebeat/filebeat.yml
echo "# You can find the \`cloud.id\` in the Elastic Cloud web UI." >> /etc/filebeat/filebeat.yml
echo "#cloud.id:" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# The cloud.auth setting overwrites the \`output.elasticsearch.username\` and" >> /etc/filebeat/filebeat.yml
echo "# \`output.elasticsearch.password\` settings. The format is `\<user\>:\<pass\>`." >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#================================ Outputs =====================================" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# Configure what output to use when sending the data collected by the beat." >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#-------------------------- Elasticsearch output ------------------------------" >> /etc/filebeat/filebeat.yml
echo "output.elasticsearch:" >> /etc/filebeat/filebeat.yml
echo "  # Array of hosts to connect to." >> /etc/filebeat/filebeat.yml
echo "  hosts: [\"$1\"]" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo " # Optional protocol and basic auth credentials." >> /etc/filebeat/filebeat.yml
echo "  protocol: \"https\"" >> /etc/filebeat/filebeat.yml
echo "  username: ${USERNAME}" >> /etc/filebeat/filebeat.yml
echo "  password: ${PASSWORD}" >> /etc/filebeat/filebeat.yml
echo "  ssl.enabled: true" >> /etc/filebeat/filebeat.yml
echo "  ssl.verification_mode: none" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#----------------------------- Logstash output --------------------------------" >> /etc/filebeat/filebeat.yml
echo "#output.logstash:" >> /etc/filebeat/filebeat.yml
echo "  # The Logstash hosts" >> /etc/filebeat/filebeat.yml
echo "  #hosts: [\"localhost:5044\"]" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Optional SSL. By default is off." >> /etc/filebeat/filebeat.yml
echo "  # List of root certificates for HTTPS server verifications" >> /etc/filebeat/filebeat.yml
echo "  #ssl.certificate_authorities: [\"/etc/pki/root/ca.pem\"]" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Certificate for SSL client authentication" >> /etc/filebeat/filebeat.yml
echo "  #ssl.certificate: \"/etc/pki/client/cert.pem\"" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "  # Client Certificate Key" >> /etc/filebeat/filebeat.yml
echo "  #ssl.key: \"/etc/pki/client/cert.key\"" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#================================ Procesors =====================================" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# Configure processors to enhance or manipulate events generated by the beat." >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "processors:" >> /etc/filebeat/filebeat.yml
echo "  - add_host_metadata: ~" >> /etc/filebeat/filebeat.yml
echo "  - add_cloud_metadata: ~" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#================================ Logging =====================================" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# Sets log level. The default log level is info." >> /etc/filebeat/filebeat.yml
echo "# Available log levels are: error, warning, info, debug" >> /etc/filebeat/filebeat.yml
echo "#logging.level: debug" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# At debug level, you can selectively enable logging only for some components." >> /etc/filebeat/filebeat.yml
echo "# To enable all selectors use [\"*\"]. Examples of other selectors are \"beat\"," >> /etc/filebeat/filebeat.yml
echo "# \"publish\", \"service\"." >> /etc/filebeat/filebeat.yml
echo "#logging.selectors: [\"*\"]" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "#============================== Xpack Monitoring ===============================" >> /etc/filebeat/filebeat.yml
echo "# filebeat can export internal metrics to a central Elasticsearch monitoring" >> /etc/filebeat/filebeat.yml
echo "# cluster.  This requires xpack monitoring to be enabled in Elasticsearch.  The" >> /etc/filebeat/filebeat.yml
echo "# reporting is disabled by default." >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# Set to true to enable the monitoring reporter." >> /etc/filebeat/filebeat.yml
echo "#xpack.monitoring.enabled: false" >> /etc/filebeat/filebeat.yml
echo "" >> /etc/filebeat/filebeat.yml
echo "# Uncomment to send the metrics to Elasticsearch. Most settings from the" >> /etc/filebeat/filebeat.yml
echo "# Elasticsearch output are accepted here as well. Any setting that is not set is" >> /etc/filebeat/filebeat.yml
echo "# automatically inherited from the Elasticsearch output configuration, so if you" >> /etc/filebeat/filebeat.yml
echo "# have the Elasticsearch output configured, you can simply uncomment the" >> /etc/filebeat/filebeat.yml
echo "# following line." >> /etc/filebeat/filebeat.yml
echo "#xpack.monitoring.elasticsearch:" >> /etc/filebeat/filebeat.yml

if [[ $DOWNLOAD_TYPE -le 2 ]]; then #deb or rpm
  filebeat setup --template
  sudo filebeat setup -e
  sudo filebeat modules enable kafka
  sudo service filebeat restart
else
  cd /etc/filebeat
  ./filebeat setup --template
  sudo chown root filebeat.yml 
  sudo chown root modules.d/kafka.yml 
  sudo ./filebeat setup -e
  sudo ./filebeat -e
fi

echo "To view your NGINX data log into your Kibana Portal at https://app.vizion.ai/kibana"
echo "Login with the Kibana credentials below that were given when you created your Vizion.ai Elastic Stack"
echo "username: ${USERNAME}  password: ${PASSWORD}"