# Parsing Log Files With Logstash

Data in Elasticsearch is stored in a JSON-like `key:value` format, but most log files come in the form of text files, where each line represents an event and contains multiple pieces of information. How do you get your log data into that `key:value` format to fully take advantage of Elasticsearch and Kibana? That's where Logstash comes in.

Logstash is a processing pipeline, capable of ingesting data form multiple sources, parsing or transforming that data, then sending it to a desired destination, such as your Vizion Elastic App. Logstash can be set up on your machine where it can automatically collect data from local files, or it can be set up on a server where it will accept data through http.

A Logstash pipeline consists of three stages:

**Inputs:** Logstash can accept multiple inputs simultaneously from sources such as http, files, beats, and stdin.

**Filters:** The filter stage comes with a wide range of capabilities. It can add or remove fields or tags. As mentioned above, it can use regular expressions (or even better, use built in filters) to parse text to structure the data in a more useful way. It can use conditionals to all of this in a very flexible, dynamic way. For example, you could look for keywords within an inputted event to determine what index to use when sending data to Elasticsearch.

**Outputs:** Logstash can send to a variety of outputs, such as a file or http, though most likely you will be sending to your Vizion Elastic instance. Again, it is very flexible and could be configured to send to one of multiple destinations based on the contents of the event.

[Example: Using Logstash to collect Apache logs, do some simple processing, and sending them to Vizion Elastic. >](./install-logstash.md)
