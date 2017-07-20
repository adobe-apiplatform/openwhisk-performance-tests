### Running the tests in Mesos

```bash
$ cd ./mesos
$ make create-locust-master
$ make create-locust-slave
```

> These commands use the `dcos` CLI.

Once apps install, open the URL to the Locust master UI using the load balancer installed in Mesos. 

To bring more locust slaves, simply scale the locust-slave app in Marathon.
