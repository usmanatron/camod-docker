# Examples

Here are some ways in which you can run this container.  Note that these are minimal examples, there are a number of settings you can tweak by setting more environment variables.  The full list is not documented anywhere, but can be checked by looking through the [launch script](../launch-dedicated.sh)

> [!WARNING]
> Accessing externally is out of scope for these examples - you'll need to handle that yourself (e.g. port forwarding, firewalls etc.)

## Docker Compose

[docker-compose.yaml](./docker-compose.yaml) contains the configuration to run camod via Docker Compose.  It's fairly self-explanatory if you've used Compose before.

## Kubernetes

[kubernetes.yaml](./kubernetes.yaml) contains Deployment and Service resources for running the camod container.  Note that ingress resources are not included; this will be very specific to your setup!

Notice that there are no liveness and readiness probes setup - this is on purpose!  When a game starts, these probes start to fail, which results in the pod getting terminated and the game crashing.  It's not yet clear if there is a sensible alternative port to point the probe at.

### Ingress via Traefik

If you are using Traefik for your ingress controller, you will need a separate Entrypoint that is setup for TCP traffic.  If using the Helm chart, it will look something like this:

```yaml
ports:
  # Other entrypoints like web, websecure...
  my-new-entrypoint:
    port: 1234
    expose:
      default: true
    exposedPort: 1234
    protocol: TCP
```

You can then use an [IngressRouteTCP](https://doc.traefik.io/traefik/reference/routing-configuration/kubernetes/crd/tcp/ingressroutetcp/) to handle ingress to the camod container.  Make sure you set the entrypoint to the new one you created in the previous step.  Have a look at [traefik-ingressroutetcp.yaml](./traefik-ingressroutetcp.yaml) for an example.

I havent tested TLS - it may work!  For now, I would recommend not setting up TLS and setting the IngressRouteTCP resource to match all traffic.  It does mean that your new entrypoint can only be used for this container, but thats likely fine.
