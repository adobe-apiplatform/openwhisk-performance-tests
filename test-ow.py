from locust import HttpLocust, TaskSet, task
import json

ACTIONS_URL_PREFIX = "/api/v1/namespaces/guest/actions"
NAMESPACE = "guest"
UUID = "23bc46b1-71f6-4ed5-8c54-816aa4f8c502"
AUTH_TOKEN = "123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP"

ACTION_NAME = "test-async"

class OWPerfTaskSet(TaskSet):
    def on_start(self):
        getActionRes = self.client.get(ACTIONS_URL_PREFIX + "/" + ACTION_NAME, auth=(UUID, AUTH_TOKEN))
        if (getActionRes.status_code == 404):
            deleteActionRes = self.client.delete(
                ACTIONS_URL_PREFIX + "/" + ACTION_NAME,
                auth = (UUID, AUTH_TOKEN)
            )

        actionCode = open("timeout.js", "r").read()
        createActionRes = self.client.put(
            ACTIONS_URL_PREFIX + "/" + ACTION_NAME,
            auth = (UUID, AUTH_TOKEN),
            headers = {
                "Content-Type": "application/json"
            },
            data = json.dumps({
                "namespace": NAMESPACE,
                "name": ACTION_NAME,
                "exec": {
                    "kind": "nodejs:default",
                    "code": actionCode
                }
            })
        )

    @task
    def invokeAction(self):
        invokeActionRes = self.client.post(
            ACTIONS_URL_PREFIX + "/" + ACTION_NAME + "?blocking=true",
            auth = (UUID, AUTH_TOKEN),
            headers = {
                "Content-Type": "application/json"
            }
        )
        print("invoke action", invokeActionRes.json())

class OWPerfLocust(HttpLocust):
    task_set = OWPerfTaskSet
    min_wait = 5000
    max_wait = 15000
