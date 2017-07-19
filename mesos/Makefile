DCOS_URL = $(shell dcos config show core.dcos_url)

.PHONY: create-locust-master
create-locust-master:
	echo "Deploying a master Locust node on " $(DCOS_URL)
	dcos marathon app add ./marathon_app_master.json

.PHONY: create-locust-slave
create-locust-slave:
	echo "Deploying locus slave on " $(DCOS_URL)
	dcos marathon app add ./marathon_app_slave.json

.PHONY: update-locust-master
update-locust-master:
	echo "Deploying a master Locust node on " $(DCOS_URL)
	dcos marathon app update locust-master < ./marathon_app_master.json

.PHONY: update-locust-slave
update-locust-slave:
	echo "Deploying locus slave on " $(DCOS_URL)
	dcos marathon app update locust-slave < ./marathon_app_slave.json

.PHONY: delete-locust-master
delete-locust-master:
	echo "Deleting locus master on " $(DCOS_URL)
	dcos marathon app remove locust-master

.PHONY: delete-locust-slave
delete-locust-slave:
	echo "Deleting locus slave on " $(DCOS_URL)
	dcos marathon app remove locust-slave
