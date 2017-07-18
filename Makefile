HOST = http://127.0.0.1:8888
AUTH_TOKEN = 23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP
ACTIONS_URL_PREFIX = $(HOST)/api/v1/namespaces/guest/actions

.PHONY: run-test-action
run-test-action: create-action invoke-action delete-action

.PHONY: create-action
create-action:
	echo "$$(tput setaf 2)creating the test action ...$$(tput sgr0)"
	curl -u $(AUTH_TOKEN) \
			 -H "Content-Type:application/json" \
			 -XPUT -d '{"namespace":"_","name":"test-async","exec":{"kind":"nodejs:default","code":"$(cat timeout.js)"}}' -H "Content-Type: application/json" \
			 $(ACTIONS_URL_PREFIX)/test-async

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

.PHONY: delete-action
delete-action:
	echo "$$(tput setaf 2)deleting the test action ...$$(tput sgr0)"
	 curl -u $(AUTH_TOKEN) \
	 		 -H "Content-Type:application/json" \
	 		 -XDELETE \
	 		 $(ACTIONS_URL_PREFIX)/test-async
