# Sample MITS API

## Environment

```
Ruby       2.3.1
Rails      5.0.0.1
PostgreSQL 9.4.1
```

---

## Public API

The source feed.

```
GET  /properties           
GET  /properties/:id       
```

Our processed JSON

```
GET  /properties/normalized
GET  /properties/:id/normalized
```

---

## Setup

Create a local copy of this project

```
$ git clone git@github.com:mnishiguchi/mits_api.git
```

Move to the project directory

```
$ cd path/to/this/project
```

Set up database

```
$ ./bin/setup
```

Start a dev server

```
$ rails server
```

Visit [http://localhost:3000/properties](http://localhost:3000/properties)

---

## Check an API endpoint using curl

```
$ curl http://127.0.0.1:3000/properties
```

```
$ curl -H 'Accept: application/vnd.mits.v1' http://127.0.0.1:3000/properties
```

---

## How to run the test suite

```bash
$ bundle exec guard
```

or

```bash
$ bundle exec rake test
```
