#! /bin/bash
echo
echo
echo "What type of download for your system?"
echo "Enter (1)for Debian, (2)for rpm, (3)for mac, (4)for tar/linux"
read DOWNLOAD_TYPE

if [[ $DOWNLOAD_TYPE -eq 1 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-6.5.4-amd64.deb
  sudo dpkg -i auditbeat-6.5.4-amd64.deb
elif [[ $DOWNLOAD_TYPE -eq 2 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-6.5.4-x86_64.rpm
  sudo rpm -vi auditbeat-6.5.4-x86_64.rpm
elif [[ $DOWNLOAD_TYPE -eq 3 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-6.5.4-darwin-x86_64.tar.gz
  tar xzvf auditbeat-6.5.4-darwin-x86_64.tar.gz
elif [[ $DOWNLOAD_TYPE -eq 4 ]]; then
  curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-6.5.4-linux-x86_64.tar.gz
  tar xzvf auditbeat-6.5.4-linux-x86_64.tar.gz
else
  echo "That was not one of the options. Exiting."
  exit 1
fi

USERNAME_REGEX="https://([a-zA-Z0-9]*):"
PASSWORD_REGEX=":([a-zA-Z0-9]*)@"

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


echo "###################### Auditbeat Configuration Example #########################" > /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# This is an example configuration file highlighting only the most common" >> /etc/auditbeat/auditbeat.yml
echo "# options. The auditbeat.reference.yml file from the same directory contains all" >> /etc/auditbeat/auditbeat.yml
echo "# the supported options with more comments. You can use it as a reference." >> /etc/auditbeat/auditbeat.yml
echo "#" >> /etc/auditbeat/auditbeat.yml
echo "# You can find the full configuration reference here:" >> /etc/auditbeat/auditbeat.yml
echo "# https://www.elastic.co/guide/en/beats/auditbeat/index.html" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#==========================  Modules configuration =============================" >> /etc/auditbeat/auditbeat.yml
echo "auditbeat.modules:" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "- module: auditd" >> /etc/auditbeat/auditbeat.yml
echo "  # Load audit rules from separate files. Same format as audit.rules(7)." >> /etc/auditbeat/auditbeat.yml
echo "  audit_rule_files: [ '\${path.config}/audit.rules.d/*.conf' ]" >> /etc/auditbeat/auditbeat.yml
echo "  audit_rules: |" >> /etc/auditbeat/auditbeat.yml
echo "    ## Define audit rules here." >> /etc/auditbeat/auditbeat.yml
echo "    ## Create file watches (-w) or syscall audits (-a or -A). Uncomment these" >> /etc/auditbeat/auditbeat.yml
echo "    ## examples or add your own rules." >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "    ## If you are on a 64 bit platform, everything should be running" >> /etc/auditbeat/auditbeat.yml
echo "    ## in 64 bit mode. This rule will detect any use of the 32 bit syscalls" >> /etc/auditbeat/auditbeat.yml
echo "    ## because this might be a sign of someone exploiting a hole in the 32" >> /etc/auditbeat/auditbeat.yml
echo "    ## bit API." >> /etc/auditbeat/auditbeat.yml
echo "    #-a always,exit -F arch=b32 -S all -F key=32bit-abi" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "    ## Executions." >> /etc/auditbeat/auditbeat.yml
echo "    #-a always,exit -F arch=b64 -S execve,execveat -k exec" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "    ## External access (warning: these can be expensive to audit)." >> /etc/auditbeat/auditbeat.yml
echo "    #-a always,exit -F arch=b64 -S accept,bind,connect -F key=external-access" >> /etc/auditbeat/auditbeat.yml
echo "        ## Identity changes." >> /etc/auditbeat/auditbeat.yml
echo "    #-w /etc/group -p wa -k identity" >> /etc/auditbeat/auditbeat.yml
echo "    #-w /etc/passwd -p wa -k identity" >> /etc/auditbeat/auditbeat.yml
echo "    #-w /etc/gshadow -p wa -k identity" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "    ## Unauthorized access attempts." >> /etc/auditbeat/auditbeat.yml
echo "    #-a always,exit -F arch=b64 -S open,creat,truncate,ftruncate,openat,open_by_handle_at -F exit=-EACCES -k$" >> /etc/auditbeat/auditbeat.yml
echo "    #-a always,exit -F arch=b64 -S open,creat,truncate,ftruncate,openat,open_by_handle_at -F exit=-EPERM -k $" >> /etc/auditbeat/auditbeat.yml
echo "- module: file_integrity" >> /etc/auditbeat/auditbeat.yml
echo "  paths:" >> /etc/auditbeat/auditbeat.yml
echo "  - /bin" >> /etc/auditbeat/auditbeat.yml
echo "  - /usr/bin" >> /etc/auditbeat/auditbeat.yml
echo "  - /sbin" >> /etc/auditbeat/auditbeat.yml
echo "  - /usr/sbin" >> /etc/auditbeat/auditbeat.yml
echo "  - /etc" >> /etc/auditbeat/auditbeat.yml
echo "  - /usr/games" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#==================== Elasticsearch template setting ==========================" >> /etc/auditbeat/auditbeat.yml
echo "setup.template.settings:" >> /etc/auditbeat/auditbeat.yml
echo "  index.number_of_shards: 3" >> /etc/auditbeat/auditbeat.yml
echo "  #index.codec: best_compression" >> /etc/auditbeat/auditbeat.yml
echo "  #_source.enabled: false" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#================================ General =====================================" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# The name of the shipper that publishes the network data. It can be used to group" >> /etc/auditbeat/auditbeat.yml
echo "# all the transactions sent by a single shipper in the web interface." >> /etc/auditbeat/auditbeat.yml
echo "#name:" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# The tags of the shipper are included in their own field with each" >> /etc/auditbeat/auditbeat.yml
echo "# transaction published." >> /etc/auditbeat/auditbeat.yml
echo "#tags: [\"service-X\", \"web-tier\"]" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# Optional fields that you can specify to add additional information to the" >> /etc/auditbeat/auditbeat.yml
echo "# output." >> /etc/auditbeat/auditbeat.yml
echo "#fields:" >> /etc/auditbeat/auditbeat.yml
echo "#  env: staging" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#============================== Dashboards =====================================" >> /etc/auditbeat/auditbeat.yml
echo "# These settings control loading the sample dashboards to the Kibana index. Loading" >> /etc/auditbeat/auditbeat.yml
echo "# the dashboards is disabled by default and can be enabled either by setting the" >> /etc/auditbeat/auditbeat.yml
echo "# options here, or by using the \`-setup\` CLI flag or the \`setup\` command." >> /etc/auditbeat/auditbeat.yml
echo "#setup.dashboards.enabled: false" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# The URL from where to download the dashboards archive. By default this URL" >> /etc/auditbeat/auditbeat.yml
echo "# has a value which is computed based on the Beat name and version. For released" >> /etc/auditbeat/auditbeat.yml
echo "# versions, this URL points to the dashboard archive on the artifacts.elastic.co" >> /etc/auditbeat/auditbeat.yml
echo "# website." >> /etc/auditbeat/auditbeat.yml
echo "#setup.dashboards.url:" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#============================== Kibana =====================================" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API." >> /etc/auditbeat/auditbeat.yml
echo "# This requires a Kibana endpoint configuration." >> /etc/auditbeat/auditbeat.yml
echo "setup.kibana:" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "  # Kibana Host" >> /etc/auditbeat/auditbeat.yml
echo "  # Scheme and port can be left out and will be set to the default (http and 5601)" >> /etc/auditbeat/auditbeat.yml
echo "  # In case you specify and additional path, the scheme is required: http://localhost:5601/path" >> /etc/auditbeat/auditbeat.yml
echo "  # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601" >> /etc/auditbeat/auditbeat.yml
echo "  host: \"https://app.vizion.ai:443/kibana\"" >> /etc/auditbeat/auditbeat.yml
echo "  username: \"${USERNAME}\"" >> /etc/auditbeat/auditbeat.yml
echo "  password: \"${PASSWORD}\"" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "  # Kibana Space ID" >> /etc/auditbeat/auditbeat.yml
echo "  # ID of the Kibana Space into which the dashboards should be loaded. By default," >> /etc/auditbeat/auditbeat.yml
echo "  # the Default Space will be used." >> /etc/auditbeat/auditbeat.yml
echo "  #space.id:" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#============================= Elastic Cloud ==================================" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# These settings simplify using auditbeat with the Elastic Cloud (https://cloud.elastic.co/)." >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# The cloud.id setting overwrites the \`output.elasticsearch.hosts\` and" >> /etc/auditbeat/auditbeat.yml
echo "# \`setup.kibana.host\` options." >> /etc/auditbeat/auditbeat.yml
echo "# You can find the \`cloud.id\` in the Elastic Cloud web UI." >> /etc/auditbeat/auditbeat.yml
echo "#cloud.id:" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# The cloud.auth setting overwrites the \`output.elasticsearch.username\` and" >> /etc/auditbeat/auditbeat.yml
echo "# \`output.elasticsearch.password\` settings. The format is \`<user>:\<pass>\`." >> /etc/auditbeat/auditbeat.yml
echo "#cloud.auth:" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#================================ Outputs =====================================" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# Configure what output to use when sending the data collected by the beat." >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#-------------------------- Elasticsearch output ------------------------------" >> /etc/auditbeat/auditbeat.yml
echo "output.elasticsearch:" >> /etc/auditbeat/auditbeat.yml
echo "  # Array of hosts to connect to." >> /etc/auditbeat/auditbeat.yml
echo "  hosts: [\"$1\"]" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "  # Optional protocol and basic auth credentials." >> /etc/auditbeat/auditbeat.yml
echo "  #protocol: \"https\"" >> /etc/auditbeat/auditbeat.yml
echo "  username: \"${USERNAME}\"" >> /etc/auditbeat/auditbeat.yml
echo "  password: \"${PASSWORD}\"" >> /etc/auditbeat/auditbeat.yml
echo "  ssl.verification_mode: none" >> /etc/auditbeat/auditbeat.yml\
echo "  timeout: 500" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#----------------------------- Logstash output --------------------------------" >> /etc/auditbeat/auditbeat.yml
echo "#output.logstash:" >> /etc/auditbeat/auditbeat.yml
echo "  # The Logstash hosts" >> /etc/auditbeat/auditbeat.yml
echo "  #hosts: [\"localhost:5044\"]" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "  # Optional SSL. By default is off." >> /etc/auditbeat/auditbeat.yml
echo "  # List of root certificates for HTTPS server verifications" >> /etc/auditbeat/auditbeat.yml
echo "  #ssl.certificate_authorities: [\"/etc/pki/root/ca.pem\"]" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "  # Certificate for SSL client authentication" >> /etc/auditbeat/auditbeat.yml
echo "  #ssl.certificate: \"/etc/pki/client/cert.pem\"" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "  # Client Certificate Key" >> /etc/auditbeat/auditbeat.yml
echo "  #ssl.key: \"/etc/pki/client/cert.key\"" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#================================ Procesors =====================================" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# Configure processors to enhance or manipulate events generated by the beat." >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "processors:" >> /etc/auditbeat/auditbeat.yml
echo "  - add_host_metadata: ~" >> /etc/auditbeat/auditbeat.yml
echo "  - add_cloud_metadata: ~" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#================================ Logging =====================================" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# Sets log level. The default log level is info." >> /etc/auditbeat/auditbeat.yml
echo "# Available log levels are: error, warning, info, debug" >> /etc/auditbeat/auditbeat.yml
echo "#logging.level: debug" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# At debug level, you can selectively enable logging only for some components." >> /etc/auditbeat/auditbeat.yml
echo "# To enable all selectors use [\"*\"]. Examples of other selectors are \"beat\"," >> /etc/auditbeat/auditbeat.yml
echo "# \"publish\", \"service\"." >> /etc/auditbeat/auditbeat.yml
echo "#logging.selectors: [\"*\"]" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "#============================== Xpack Monitoring ===============================" >> /etc/auditbeat/auditbeat.yml
echo "# auditbeat can export internal metrics to a central Elasticsearch monitoring" >> /etc/auditbeat/auditbeat.yml
echo "# cluster.  This requires xpack monitoring to be enabled in Elasticsearch.  The" >> /etc/auditbeat/auditbeat.yml
echo "# reporting is disabled by default." >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# Set to true to enable the monitoring reporter." >> /etc/auditbeat/auditbeat.yml
echo "#xpack.monitoring.enabled: false" >> /etc/auditbeat/auditbeat.yml
echo "" >> /etc/auditbeat/auditbeat.yml
echo "# Uncomment to send the metrics to Elasticsearch. Most settings from the" >> /etc/auditbeat/auditbeat.yml
echo "# Elasticsearch output are accepted here as well. Any setting that is not set is" >> /etc/auditbeat/auditbeat.yml
echo "# automatically inherited from the Elasticsearch output configuration, so if you" >> /etc/auditbeat/auditbeat.yml
echo "# have the Elasticsearch output configured, you can simply uncomment the" >> /etc/auditbeat/auditbeat.yml
echo "# following line." >> /etc/auditbeat/auditbeat.yml
echo "#xpack.monitoring.elasticsearch:" >> /etc/auditbeat/auditbeat.yml


if [[ $DOWNLOAD_TYPE -le 2 ]]; then #deb or rpm
  auditbeat setup --template
  sudo service auditbeat start
else
  ./auditbeat setup --template
  sudo chown root auditbeat.yml
  sudo ./auditbeat -e
fi