from locust import HttpLocust, TaskSet, task

class OWPerfTaskSet(TaskSet):
    @task
    def pingController(self):
        invokeActionRes = self.client.get("/api/v1")
        print("api", invokeActionRes.content)

class OWPerfLocust(HttpLocust):
    task_set = OWPerfTaskSet
