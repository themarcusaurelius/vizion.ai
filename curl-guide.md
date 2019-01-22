# Using cURL to Interact With Your Vizion-ELK API
Elasticsearch operates as a REST API and be interfaced with any number of tools that make http requests. For this guide,
we will use cURL, available in the Mac or Linux console, to illustrate some basic commands. Note that this guide represents a small
fraction of Elasticsearch's capabilities. Much more can be found in [the official docs](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs.html).

## Creating a new index
In Elasticsearch, an index is a set of related data, similar to a 'database' in relational databases. For example, one might have a *product* index or an *employees* index.

````
curl -XPUT '< Your Elasticsearch URL >/< Index name >'
````
*you may choose to use -k before the address so as not to need ssl certificates*

## Creating a document
A 'document' is the Elasticsearch equivalent of a 'row' in relational databases. It is represented as a JSON object of fields and values. ES automatically supports a wide array of datatypes, including strings, numbers, booleans, datetimes, arrays, nested objects. Documents need no schema and can accept whatever fields are assigned.

Here we will create a document in an index called 'person', an index which did not previously exist. No problem, Elasticsearch automatically creates it!

````
curl -XPUT '< Your Elasticsearch URL >/person/_doc/1'
'{
  "name": "Josephina Echerson",
  "nickNames": ["Josie Jo", "Raspberry Jo"]
  "bornAt": 601454129,
 }'
 ````
 Now we have an index for person type things, and one document of a person type thing with an "_id" of 1 the "name: "Josephina Echerson".
 
 ## Create Many Documents with a JSON File
 
 ````
 curl -XPOST '<Your Elasticsearch URL >/index ' -d <path to data>.json
 ````
## Searching an Index
Elasticsearch accepts queries in the form of JSON, often with nested layers of specifications. First it must be declared if the search is a query or if it a filter. The difference between the two is that a query calculates a score for each document based on the relevance to search criteria, then returns a ranked list. A filter merely filter out all documents that don't meet a certain criteria. This is a yes or no proposition, needs no ranking, and thus needs less computation.
