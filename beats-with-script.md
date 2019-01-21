# Using scripts to quickly install and configure Beats
Beats is the platform for single-purpose data shippers. They send data from your machines and systems to Elasticsearch, which can be then be seen in Kibana with built-in dashboards and visualizations. Each Beat type also has a set of modules that provide additional functionality and can be enabled easily.

## Filebeat
Filebeat is a lightweight shipper for log data, that will automatically crawl your log files and send log data to your Vizion Elk app. [more](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-overview.html)

To install and configure Filebeat, enter the following into your console along with the url given to you when you created your Vizion ELK app. Make sure you are using elevated privileges for the install.

    curl ec2-54-184-247-238.us-west-2.compute.amazonaws.com/install-config-metricbeat.sh > install-config-metricbeat.sh; chmod a+x    install-config-metricbeat.sh; ./install-config-metricbeat.sh << your Vizion ELK url here >>

The intallation script will prompt you to select the proper environment, then will install and complete basic configuration automatically.

To enable a module, enter `filebeat modules enable << module name >>` or `./filebeat modules enable << module name >>`

Modules available: *Apache2, Auditd, Elasticsearch, haproxy, Icinga, IIS, Kafka, Kibana, Logstash, MongoDB, MySQL, Nginx, Osquery, PostgreSQL, Redis, Suricata, System, Traefik*

[More on Filebeat modules](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-modules-overview.html)

**You should now be sending data to your Vizion ELK app. View it in [Kibana](https://app.vizion.ai/app/kibana)**

For debugging, you can view your Filebeat error logs at `/var/log/filebeat/filebeat` or change the configuration at `/etc/filebeat/filebeat.yml`.


## Metricbeat
Metricbeat is a lightweight shipper for metric data, that will send system data and metrics to your Vizion Elk app. [more](https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-overview.html)

To install and configure Metricbeat, enter the following into your console along with the url given to you when you created your Vizion ELK app. Make sure you are using elevated privileges for the install.

    curl ec2-54-184-247-238.us-west-2.compute.amazonaws.com/install-config-metricbeat.sh > install-config-metricbeat.sh; chmod a+x    install-config-metricbeat.sh; ./install-config-metricbeat.sh << your Vizion ELK url here >>
    
The intallation script will prompt you to select the proper environment, then will install and complete basic configuration automatically.

To enable a module, enter `metricbeat modules enable << module name >>` or `./metricbeat modules enable << module name >>`

Modules available: *Aerospike, Apache, Ceph, Couchbase, Docker, Dropwizard, Elasticsearch, envoyproxy, Etcd, Golang, Graphite, HAProxy, HTTP, Jolokia, Kafka, Kibana, Kubernetes, kvm, Logstash, Memcached, MongoDB, Munin, MySQL, Nginx, PHP_FPM, PostgreSQL, Prometheus, RabbitMQ, Redis, System, traefik, uwsgi, vSphere, Windows, ZooKeeper*

[More on Metricbeat modules](https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-modules.html)

**You should now be sending data to your Vizion ELK app. View it in [Kibana](https://app.vizion.ai/app/kibana)**

For debugging, you can view your Metricbeat error logs at `/var/log/metricbeat/metricbeat` or change the configuration at `/etc/metricbeat/metricbeat.yml`.



## Auditbeat
Auditbeat is a lightweight shipper that you can install on your servers to audit the activities of users and processes on your systems and send the data to your Vizion Elk app. [more](https://www.elastic.co/guide/en/beats/auditbeat/current/auditbeat-overview.html)

To install and configure Auditbeat, enter the following into your console along with the url given to you when you created your Vizion ELK app. Make sure you are using elevated privileges for the install.

    curl ec2-54-184-247-238.us-west-2.compute.amazonaws.com/install-config-metricbeat.sh > install-config-metricbeat.sh; chmod a+x    install-config-metricbeat.sh; ./install-config-metricbeat.sh << your Vizion ELK url here >>

The intallation script will prompt you to select the proper environment, then will install and complete basic configuration automatically.

Auditbeat comes with two modules already running - Auditd and File Integrity. File integrity tracks changes to files within specified directories. You can change which directories will be tracked (beyond the defaults) in the Auditbeat config file: `/etc/auditbeat/auditbeat.yml`. Auditd rules are specified in their own files in the folder `/etc/auditbeat/audit.rules.d`.

[More on Auditbeat modules](https://www.elastic.co/guide/en/beats/auditbeat/current/auditbeat-modules.html)

**You should now be sending data to your Vizion ELK app. View it in [Kibana](https://app.vizion.ai/app/kibana)**

For debugging, you can view your Auditbeat error logs at `/var/log/auditbeat/auditbeat` or change the configuration at `/etc/auditbeat/auditbeat.yml`.

## Heartbeat
Heartbeat is a lightweight daemon that you install on a remote server to periodically check the status of your services and determine whether they are available. This uptime data can then be sent to your Vizion Elk app. [more](https://www.elastic.co/guide/en/beats/heartbeat/current/heartbeat-overview.html)

To install and configure Heartbeat, enter the following into your console along with the url given to you when you created your Vizion ELK app. Make sure you are using elevated privileges for the install.

    curl ec2-54-184-247-238.us-west-2.compute.amazonaws.com/install-config-metricbeat.sh > install-config-metricbeat.sh; chmod a+x    install-config-metricbeat.sh; ./install-config-metricbeat.sh << your Vizion ELK url here >>

The intallation script will prompt you to select the proper environment.

Add the urls for Heartbeat to monitor by opening `/etc/hearbeat/heartbeat.yml` and adding them to the array in the field `urls:` under `heartbeat.monitors:` using [YAML syntax](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)

**You should now be sending data to your Vizion ELK app. View it in [Kibana](https://app.vizion.ai/app/kibana)**

For debugging, you can view your Metricbeat error logs at `/var/log/heartbeat/heartbeat` or change the configuration at `/etc/heartbeat/heartbeat.yml`.

## Packetbeat
Packetbeat is a real-time network packet analyzer that you can use with your Vizion ELK app to provide an application monitoring and performance analytics system. [more](https://www.elastic.co/guide/en/beats/packetbeat/current/packetbeat-overview.html)

To install and configure Packetbeat, enter the following into your console along with the url given to you when you created your Vizion ELK app. Make sure you are using elevated privileges for the install.

    curl ec2-54-184-247-238.us-west-2.compute.amazonaws.com/install-config-metricbeat.sh > install-config-metricbeat.sh; chmod a+x    install-config-metricbeat.sh; ./install-config-metricbeat.sh << your Vizion ELK url here >>

The intallation script will prompt you to select the proper environment, then will install and complete basic configuration automatically.

**You should now be sending data to your Vizion ELK app. View it in [Kibana](https://app.vizion.ai/app/kibana)**

For debugging, you can view your Metricbeat error logs at `/var/log/packetbeat/packetbeat` or change the configuration at `/etc/packetbeat/packetbeat.yml`.
