from locust import HttpLocust, TaskSet, task

AUTH_TOKEN = "23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP"
ACTIONS_URL_PREFIX = "/api/v1/namespaces/guest/actions"
NAMESPACE = "23bc46b1-71f6-4ed5-8c54-816aa4f8c502"
AUTH_TOKEN = "123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP"

class OWTaskSet(TaskSet):
    @task(1)
    def listActions(self):
        self.client.get(ACTIONS_URL_PREFIX, auth=(NAMESPACE, AUTH_TOKEN))

class OWLocust(HttpLocust):
    task_set = OWTaskSet
    min_wait = 5000
    max_wait = 15000
