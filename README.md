# openwhisk-performance-tests
A suite of performance tests for Openwhisk based on [Locust.io](http://locust.io/).

### Setting up

```bash
$ make create-actions
```
This command creates 2 actions:
* `test-async` - an async action that returns after a timeout
* `test-async-sequence` - a sequence action composed of 3 `test-async` actions

### Running the tests from the local machine

#### Using Locust

Make sure Locust is installed on the machine and then execute:

```bash
$ locust --host http://openwhisk_host -f test-ow.py
```

#### Using Docker with Locust Master and Slave

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
