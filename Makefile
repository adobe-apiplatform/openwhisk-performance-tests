HOST ?= $(shell cat ~/.wskprops | grep HOST | awk -F= '{print $$2}')
AUTH_TOKEN ?= $(shell cat ~/.wskprops | grep AUTH | awk -F= '{print $$2}')
NAMESPACE ?= $(shell cat ~/.wskprops | grep NAMESPACE | awk -F= '{print $$2}')
ACTIONS_URL_PREFIX ?= $(HOST)/api/v1/namespaces/$(NAMESPACE)/actions
ACTION_CODE = $(shell cat timeout.js | sed  s/\"/\\\\\"/g | awk '{printf "%s\\n", $$0}')

.PHONY: docker
docker:
	docker build -t whisk/locustio .

.PHONY: run-test-action
run-test-action: create-actions invoke-action delete-action

.PHONY: create-actions
create-actions:
	echo "$$(tput setaf 2)creating the test action ...$$(tput sgr0)"
	curl -u $(AUTH_TOKEN) \
			 -H "Content-Type:application/json" \
			 -XPUT -d '{"namespace":"_","name":"test-async","exec":{"kind":"nodejs:default","code":"$(ACTION_CODE)"}}' -H "Content-Type: application/json" \
			 $(ACTIONS_URL_PREFIX)/test-async
	echo "$$(tput setaf 2)creating the sequence test action ...$$(tput sgr0)"
	curl -u $(AUTH_TOKEN) \
 			 -H "Content-Type:application/json" \
 			 -XPUT -d '{"namespace":"'$(NAMESPACE)'","name":"test-async-sequence","exec":{"kind":"sequence","components":["/'$(NAMESPACE)'/test-async","/'$(NAMESPACE)'/test-async","/'$(NAMESPACE)'/test-async"]}}' -H "Content-Type: application/json" \
 			 $(ACTIONS_URL_PREFIX)/test-async-sequence

.PHONY: list-actions
list-actions:
	echo "list all actions"
	curl -u $(AUTH_TOKEN) \
			 -H "Content-Type:application/json" \
			 $(ACTIONS_URL_PREFIX)

.PHONY: invoke-action
invoke-action:
	echo "$$(tput setaf 2)invoking the test action ...$$(tput sgr0)"
	docker run \
			--net host \
	    jordi/ab ab -k -n 20 -c 2 \
			-A $(AUTH_TOKEN) \
	    -m POST -H "Content-Type:application/json" \
	            $(ACTIONS_URL_PREFIX)/test-async?blocking=true

.PHONY: delete-actions
delete-actions:
	echo "$$(tput setaf 2)deleting the test action ...$$(tput sgr0)"
	curl -u $(AUTH_TOKEN) \
		 -H "Content-Type:application/json" \
		 -XDELETE \
		 $(ACTIONS_URL_PREFIX)/test-async
	echo "$$(tput setaf 2)deleting the test action ...$$(tput sgr0)"
	curl -u $(AUTH_TOKEN) \
			 -H "Content-Type:application/json" \
			 -XDELETE \
			 $(ACTIONS_URL_PREFIX)/test-async-sequence
