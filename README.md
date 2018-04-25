# ElasticSearch + Vue

This is a demonstration application.  It demonstrates how to query an ElasticSearch data source and present the results as a chart using the Vue framework.

## Requires

* Rails: 5.2.0
* Ruby:  2.3.4

## Installation

Install according to standard Rails app installation procedure.

### DotEnv

The app/service requires ElasticSearch credentials to be stored in a `.env` file; or otherwise in environment variables.
The `.env` file needs to store:

```bash
  export DATA_HOST=xxx.xxxxxxxx.xxx
  export DATA_USER=xxxxxx
  export DATA_PASSWORD=xxxxxxxxxxxxxxxxxxxxxxxxx
```

## Usage

The service is used by POSTing JSON data to `/page_views`.

### Example

```bash
  curl -X POST http://localhost:3000/page_views \
    -H "accept: application/json" \
    -H "cache-control: no-cache" \
    -H "content-type: application/json" \
    -d "{
    "urls": [
      "http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615",
      "http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html",
      "http://www.smh.com.au/nsw/premier-gladys-berejiklian-announces-housing-affordability-reforms-20170601-gwi0jn.html",
      "http://www.news.com.au/technology/environment/trump-pulls-us-out-of-paris-climate-agreement/news-story/f5c30a07c595a10a81d67611d0515a0a"
    ],
      "after":  "2017 June 1",
      "before": "2017 June 2",
    "interval": "2h"
  }'
```

## Author

Luis Esteban
