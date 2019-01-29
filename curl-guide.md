# Using cURL to Interact With Your Vizion-ELK API
Elasticsearch operates as a REST API, and be interfaced with any number of tools that make http requests. For this guide,
we will use cURL, available in the Mac or Linux console, to illustrate some basic commands. For an even easier way to practice, you can open up Kibana and use 'Dev Tools' which can be found on the left navigation bar.

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
Let's check out the most basic query, the match query. The query looks for the provided search term(s) within the field specified. Notice this query uses the '\_search' endpoint and an optional parameter to specify the index to search in. 
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
Note also that if multiple words are used as search terms, they are tokenized and searched as if separate terms. Remember that a query calculates relevance scores for each document in the index and returns the documents with the highest relevance scores. This means that the query will return documents that may only contain some of the search terms you provided and the terms may not appear in the order you specified. To do that, you should use a 'match_phrase' query:

#### Match Phrase
The 'match_phrase' query should be used when searching for multiple words in a specific order, here is an example of searching a field for the phrase 'cool as a cucumber'
````
curl -XGET "< ES URL >/< index >/_search" -H 'Content-Type: application/json' -d
'{
  "query": {
    "match_phrase": {
      "< field >" : "cool as a cucumber" 
    }
  }
}'
````
This will return high scores for documents that have this whole phrase, and not for just having the word 'cucumber' in it.

#### Range Queries
Elasticsearch allows you to search for documents where number and date data types fall within specified ranges. For this, use a 'range' query, specify the field we want to search and then pass an object containing the constraints. In this example, I will search for a documents in the 'book' index, that have between 330 and 360 pages (inclusive).
````
curl -XGET "< ES URL >/book/_search" -H 'Content-Type: application/json' -d
'{
  "query": {
    "range": {
      "pages" : {
        "gte": 330,
        "lte": 360
      }
    }
  }
}'
````
As you see, we used an object to specify the range to search for within in the 'pages' field. We used 'gte' to specify 'greater than or equal to', 'lte' for 'less than or equal to', but could have also used 'gt' or 'lt' for exclusive ranges.

#### Wildcard/Regex Queries
Elasticsearch has built-in capabilities for wildcard searches. SImply specify if you are doing a wildcard search and use a '?' to represent any one character or '\*' to represent any number of characters. For example 'the?' would match 'they, them, then, etc.' and in the example below, we will be searching an index of patients for anyone who has a condition that encs in 'phobia'.
````
curl -XGET "< ES URL >/patient/_search" -H 'Content-Type: application/json' -d
'{
  "query": {
    "wildcard": {
      "condition" : "*phobia"
      }
    }
  }
}'
````
You have even more capabilities by using the Regex search. Here we will search for a book whose title begins with one or more numerals.
````
curl -XGET "< ES URL >/book/_search" -H 'Content-Type: application/json' -d
'{
  "query": {
    "regex": {
      "title" : "^[0-9]+"
      }
    }ent 
  }
}'
````
Note: Wildcards and regex searches can require a lot of computation. Be careful hasot to make them too general (such as a '\*' wildcard after only a couple of letters) or else your searches can become very very slow.

## Compound Queries
Elasticsearch supports compound queries, which allow a higher level of flexibility and complexity within your searches. The 'bool' query allows you to serch for documents that satisfy a combination of requirements. For example, the following will search for a document in the 'book' index that has the term "voice" in the 'title' field, but does not contain the phrase "coming of age" in the 'description' field.
````
curl -XGET "< ES URL >/book/_search" -H 'Content-Type: application/json' -d
'{
  "query": {
    "bool": {
      "must" : {
        "match": {
          "title" : "voice"
        }
      },
      must_not: {
        "match_phrase": {
          "description" : "coming of age"
        }
      }
    }
  }
}'
````
Notice the use of 'must' and 'must_not' clauses above. They work as you might expect and only return results that satisfy the criteria nested within. Also available is 'should' which boosts the scores of documents that meet the criteria but does not explicitly require them. 

## Sorting and Aggregating Results

#### Source Filtering
You may have noticed that the results of your queries contain a '\_source' object, which contains the data put into that document at creation/update. When searching, you can specify a set of fields for this object to include by passing in a '\_source' clause with an array of the desired fields. Here is a query that will return just the first and last names of all students with a grade above 90.
````
curl -XGET "< ES URL >/studnets/_search" -H 'Content-Type: application/json' -d
'{
  "query": {
    "_source": ["firstName", "lastName"],
    "range": {  
      "grade": {
        "gt": 90
      }
    }
  }
}'
````
#### Pagination
When expecting large numbers of results, you will probably want to use pagination to work with those results in managable chunks. Using the 'size' clause in your search will specify how many results to return. Note that 'size' **defaults to 10, meaning you will see only the top 10 results by default.** The 'from' clause specifies where to start returning results, with the first result numbered 0 (the default if you don't include a 'from').
````
curl -XGET "< ES URL >/book/_search" -H 'Content-Type: application/json' -d
'{
  "query": {
    "size": 20,
    "from": 20,
    "match": {  
      "title": "girl"
    }
  }
}'
````
Above is an example of a search for books whose title includes the word 'girl'. The 'size' clause specifies that a maximum of 20 documents will be returned, starting at the beginning of the secong "page" (matches 0-19 making up the first page).

#### Sorting
With the 'sort' clause, you can specify a field to sort by and whether to sort it ascending or descending. Here we will search our 'book' index again, this time for titles that include the word 'night'. We want the results to be sorted by the datetime field 'dateOfPublication' and are concerned with the newest titles, thus usin 'desc' for descending order.
````
curl -XGET "< ES URL >/book/_search" -H 'Content-Type: application/json' -d
'{
  "query": {
    "sort": {
      "dateOfPublication": "desc"
    }
    "match": {  
      "title": "girl"
    }
  }
}'
````

#### Aggregations
Elasticsearch has some useful tools for aggregating numeric fields. An 'aggs' query can return the 'min', 'max', 'avg', 'sum', and 'count' of a numeric field of a set of documents. Below we will find the low, high, and average scores.
````
curl -XGET "< ES URL >/test_scores/_search" -H 'Content-Type: application/json' -d
'{
  "query": {
    "size": 0,
    "aggs": {
      "low_score": {
        "min": {
          "field": "score"
        }
      },
       "high_score": {
        "max": {
          "field": "score"
        }
      },
       "average_score": {
        "avg": {
          "field": "score"
        }
      }
    }
  }
}'
````
Note that the fields 'min_score', 'max_score', etc. are arbitrary names that we have assigned to each aggregation. This is what that agg will be labeled in the results. Note also that we have set 'size' to 0. This way the search doesn't return any documents themselves, only the aggregations.
