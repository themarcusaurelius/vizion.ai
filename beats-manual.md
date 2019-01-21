# Install Beats Manually
Beats is the platform for single-purpose data shippers. They send data from your machines and systems to Elasticsearch, which can be then be seen in Kibana with built-in dashboards and visualizations. Each Beat type also has a set of modules that provide additional functionality and can be enabled easily.

## Download your beat
* [Filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation.html) - a lightweight shipper for log data, that will automatically crawl your log files and send log data to your Vizion Elk app.
* [Metricbeat](https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-installation.html) - a lightweight shipper for metric data, that will send system data and metrics to your Vizion Elk app.
* [Auditbeat](https://www.elastic.co/guide/en/beats/auditbeat/current/auditbeat-installation.html) - a lightweight shipper that you can install on your servers to audit the activities of users and processes on your systems and send the data to your Vizion Elk app.
* [Heartbeat](https://www.elastic.co/guide/en/beats/heartbeat/current/heartbeat-installation.html) - a lightweight daemon that you install on a remote server to periodically check the status of your services and determine whether they are available. 
* [Packetbeat](https://www.elastic.co/guide/en/beats/packetbeat/current/packetbeat-installation.html) - a real-time network packet analyzer that you can use with your Vizion ELK app to provide an application monitoring and performance analytics system. 

## Configure your beat to connect to Vizion ELK

Your beat is configured with a YAML file, located at `/etc/<beat name>/<beat name>.yml` and comes set with sensible defaults. The main thing to configure is the connection to your Vizion ELK app and to Kibana (to install dashboards). To do this, you will need to separate your Vizion Elk url into components to get your username, password, and appId.

![graph on parsing vizion ELK URL](./assets/images/app-credentials-split.png)

Enter these credentials in the sections for Kibana, and Outputs - Elasticsearch
````
#============================== Kibana =====================================

# Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API.
# This requires a Kibana endpoint configuration.
setup.kibana:

  # Kibana Host
  # Scheme and port can be left out and will be set to the default (http and 5601)
  # In case you specify and additional path, the scheme is required: http://localhost:5601/path
  # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601
  host: "https://app.vizion.ai:443"
  protocol: "https"
  username: "<< your Vizion ELK username >>"
  password: "<< your Vizion ELK password >>"
````
and
````
#================================ Outputs =====================================

# Configure what output to use when sending the data collected by the beat.

#-------------------------- Elasticsearch output ------------------------------
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["<< your Vizion ELK url >>:443"]

  # Optional protocol and basic auth credentials.
  #protocol: "https"
  username: "<< your Vizion ELK username >>"
  password: "<< your Vizion ELK password >>"
  ssl.verification_mode: none
  headers:
    vizion-es-app-id: << your Vizion ELK appId >>
  timeout: 500
````
Be sure to include port 443 at the end of you Vizion ELK url as above.

## Modules
Filebeat and Metricbeat come with optional modules, which, when enabled, add functionality to the beat. For example, Metricbeat has a Docker module that will send Metrics on Docker and any containers stored on your machine.
To see what modules are available (as well as which have been enabled), enter:

`<beat name> modules list` or `./<beat name> modules list`

To enable or disable a module:

`<beat name> modules enable(or disable) <module name>` or `./<beat name> modules enable(or disable) <module name>`

Configuration files for individual modules are found in '/etc/<beat name>/modules.d`
More on [Filebeat modules](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-modules-overview.html) or [Metricbeat modules](https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-modules.html)

## Start Your Beat
To setup your beat and load the dashboards, enter:

`<beat name> setup -e` or `./<beat name> setup -e`

Then run your beat with:

`service <beat name> start`

or for mac/linux:

`sudo chown root filebeat.yml`

`sudo ./filebeat -e`

## View Your Data
Log into your Kibana console at: https://app.vizion.ai/app/kibana
