# MITS API

## Ruby version
- `2.3.1`


## Set up the Pow development server

- [docs](http://pow.cx/)

Install Pow

```bash
$ curl get.pow.cx | sh
```

Create a symlink to the Pow server

```bash
$ cd ~/.pow
$ ln -s /path/to/mits_api
```

Visit `http://mits_api.dev/`.

## Check an API endpoint using curl

```
$ curl -H 'Accept: application/vnd.mits.v1' http://api.mits.dev/users/1
```


## How to run the test suite

```bash
$ bundle exec guard
```

or

```bash
$ rake test
```


## MITS Scmema
- `./db/feeds/ash_a.xml`
