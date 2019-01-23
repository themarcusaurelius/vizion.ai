# Using cURL to Interact With Your Vizion-ELK API
Elasticsearch operates as a REST API and be interfaced with any number of tools that make http requests. For this guide,
we will use cURL, available in the Mac or Linux console, to illustrate some basic commands. An even easier way to practice is to open up Kibana and use 'Dev Tools' which can be found on the left navigation bar.

![Find Dev Tools](./images/find-dev-tools.png)

Note that this guide represents a small
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
 
 ## Create many documents with a JSON file
 
 ````
 curl -XPOST '< Your Elasticsearch URL >/< index >' -d <path to data>.json
 ````
 
## Retrieving a document
Retrieving the JSON data for a document is easy with the document id:
 ````
 curl -XPOST '<Your Elasticsearch URL >/< index >/< id > ' -d <path to data>.json
 ````
 But you're probably not using Elasticsearch to look things up by id's. You want to be able to search other content for key words, phrases, and multiple conditions.
 
## Searching an Index
#### Query vs. Filter
Elasticsearch accepts queries in the form of JSON, often with nested layers of specifications. First it must be declared if the search is a query or if it is a filter. The difference between the two is that a query calculates a score for each document based on the relevance to search criteria, then returns a ranked list. A filter merely filter out all documents that don't meet a certain criteria. This is a yes or no proposition, needs no ranking, and thus needs less computation. 
#### The Match Query
Let's check out the most basic query, the match query. The query looks for the provided search term(s) withing the field specified. Notice this query uses the '\_search' endpoint and an optional parameter to specify the index to search in. 
````
curl -XGET "< ES URL >/< index (optional)>/_search" -H 'Content-Type: application/json' -d
'{
  "query": {
    "match": {
      "< field >" : "< search term(s) >" 
    }
  }
}'
````
Note also that if multiple words are used as search terms, they are tokenized and searched as if separate terms. Remember that a query calculates relevance scores for each document in the index and returns the documents with the highest relevance scores.
