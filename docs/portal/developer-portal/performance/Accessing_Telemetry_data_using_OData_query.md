# Accessing Telemetry data using OData query

The metrics data can be viewed through the Fabric Manager API with OData query.syntax. These are a few query examples.

`top`

: `top` returns top numbers of metrics from the database. They are not guaranteed to be latest metrics unless the query is
combined with orderby timestamp in descending order.

    ```screen
    curl -LG 'http://{fmn-baseUrl}/metrics?$top=1' |jq
    {
    "totalCount": 1,
    "documentLinks": [
    "/metrics/e1ed54dc19deb6755b8ceb3cc4253"
    ],
    "documentCount": 1,
    "queryTimeMicros": 9000,
    13
    "documentVersion": 0,
    "documentUpdateTimeMicros": 0,
    "documentExpirationTimeMicros": 0,
    "documentOwner": "5d4eec49-1478-4807-a874-7a7ff885ce71"
    }
    ```

`limit` 

: `limit` returns number of metrics per page. You can navigate to the next or previous page by clicking the **nextPageLink** or
**prevPageLink**.

    ```screen
    curl -LG 'http://{fmn-baseUrl}/metrics?$limit=3'
    {
    "totalCount": 3,
    "documentLinks": [
    "/metrics/e1ed54dc19deb6755b8ceb3cc4253",
    "/metrics/e1ed54dc19deb6755b8ceb3cc462e",
    "/metrics/e1ed54dc19deb6755b8ceb3cc4637"
    ],
    "documentCount": 3,
    "nextPageLink": "/metrics?path=1610576732165000&peer=5d4eec49-1478-4807-a874-7a7ff885ce71",
    "queryTimeMicros": 5000,
    "documentVersion": 0,
    "documentUpdateTimeMicros": 0,
    "documentExpirationTimeMicros": 0,
    "documentOwner": "5d4eec49-1478-4807-a874-7a7ff885ce71"
    }
    ```

`count`

: count returns the total number of metrics of a query result.

    ```screen
    curl -LG 'http://{fmn-baseUrl}/metrics?$count=true'
    {
    "totalCount": 12490,
    "documentLinks": [],
    "documentCount": 12490,
    "queryTimeMicros": 66999,
    "documentVersion": 0,
    "documentUpdateTimeMicros": 0,
    "documentExpirationTimeMicros": 0,
    "documentOwner": "5d4eec49-1478-4807-a874-7a7ff885ce71"
    }
    ```

`filter`

: filter returns a subset of metrics match criteria specified in query option.

    ```screen
    curl -LG 'http://{fmn-baseUrl}/metrics?$filter=Location%20eq%20%27x2006c0r39a0l1%27&$top=1'
    {
    "totalCount": 1,
    "documentLinks": [
    "/metrics/e1ed54dc19deb6755b8ceb3cc4253"
    ],
    "documentCount": 1,
    "queryTimeMicros": 6000,
    "documentVersion": 0,
    "documentUpdateTimeMicros": 0,
    "documentExpirationTimeMicros": 0,
    "documentOwner": "5d4eec49-1478-4807-a874-7a7ff885ce71"
    }
    ```

The above example uses the `eq` (equal) logical operator.