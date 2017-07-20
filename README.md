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

By default the test assumes a `guest` namespace and some default credentials for it. To configure these parameters define the following environment variables: `OW_NAMESPACE`, `OW_UUID`, `OW_KEY`. To read them directly from the `~/.wskprops` issue the commands bellow:

```bash
export OW_NAMESPACE=`wsk namespace list | grep -v namespaces`
export OW_UUID=`cat ~/.wskprops | grep AUTH | awk -F= '{print $2}' | awk -F: '{print $1}'`
export OW_KEY=`cat ~/.wskprops | grep AUTH | awk -F= '{print $2}' | awk -F: '{print $2}'`
```

#### Using Docker with Locust Master and Slave

```bash
$ make docker
```

This command builds the docker container with locust dependencies, and includes in it the tests in this repo.

Next, start a master Locust node:

```bash
$ docker run --rm --name locustio.master \
  -p 8089:8089 \
  -e OW_NAMESPACE -e OW_UUID -e OW_KEY \
    whisk/locustio --master --host http://openwhisk_host -f test-ow.py
```

Then start slaves using the command bellow:
```bash
$ docker run --rm --link locustio.master \
  -e OW_NAMESPACE -e OW_UUID -e OW_KEY \
    whisk/locustio --slave --master-host locustio.master --host http://openwhisk_host -f test-ow.py
```
