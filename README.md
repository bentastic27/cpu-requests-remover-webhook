A mutating webhook to remove CPU requests from pods. This is useful in homelab environments where CPU cores are limited, but actual usage is healthy. This prevents scheduling issues if you have a lot of helm deployments that add a lot of pods with cpu requests.

Credit to [garethr/kubernetes-webhook-examples](https://github.com/garethr/kubernetes-webhook-examples) for the Python code to speed things along for me.

