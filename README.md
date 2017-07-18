# openwhisk-performance-tests
A suite of performance tests for Openwhisk based on [Locust.io](http://locust.io/).

### Running the tests from the local machine

```bash
$ make docker
```

This command builds the docker container with locust dependencies, including the tests in this repo.

Next, start a master Locust node:

```bash
$ docker run --rm --name locustio.master -p 8089:8089 whisk/locustio --master --host http://openwhisk_host -f test-ow.py
```

Then start slaves using the command bellow:
```bash
$ docker run --rm --link locustio.master whisk/locustio --slave --master-host master --host http://openwhisk_host -f test-ow.py
```
