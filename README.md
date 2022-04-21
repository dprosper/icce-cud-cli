# Deploy to IBM Cloud Code Engine

A GitHub action to deploy an application to IBM Cloud Code Engine.

## Usage

```yml
      - name: Deploy to IBM Cloud Code Engine
        uses: dprosper/icce-cud-cli@v0.4.0
        with:
          IMAGE: ${{ env.REGISTRY_ORG_NAMESPACE }}/${{ env.REGISTRY_REPOSITORY }}:${{ github.event.pull_request.head.sha }}
          REGISTRY_USER: ${{ secrets.DOCKERHUB_USER }}
          REGISTRY_PASSWORD: ${{ secrets.DOCKERHUB_TOKEN }}
          CE_ACTION: create
          CE_PROJECT_NAME: project-${{ github.event.pull_request.head.sha }}
          CE_APP_NAME: app-${{ github.event.pull_request.head.sha }}
          REGISTRY: ${{ env.REGISTRY }}
          CE_REGISTRY_SECRET: ${{ env.CE_REGISTRY_SECRET }}
```

### Inputs

| Name | Description | Default |
| --- | --- | --- |
| `APP_SECRET` | A secret of some sort, if needed by the application. | |
| `IMAGE` | The name of the image that is used for the application.  | |
| `REGISTRY` | The URL of the registry server. | `https://index.docker.io/v1/` |
| `REGISTRY_USER` | The username to access the registry server. | |
| `REGISTRY_PASSWORD` | The password to access the registry server. | |
| `CE_REGISTRY_SECRET` | The name of the image registry access secret when added to the project. | `registry-secret` |
| `CE_ACTION` | Determines the steps to run in the action, `create`, `update` or `delete`. | |
| `CE_PROJECT_NAME` | The name of the project. Use a name that is unique within the region. | `demo-project` |
| `CE_APP_NAME` | The name of the application. Use a name that is unique within the project. | `demo-app` |
| `APP_PORT` | The port used by the application. | `3000` |

> Note: Only the IBM Cloud official plug-in repository is supported in this action.

The action can take additional input from `json` files located in the same directory as the workflow file:
  - If a `icce-project-config.json` is found it is processed, it supports creating [configmaps](https://cloud.ibm.com/docs/codeengine?topic=codeengine-configmap-secret#configmap-create) from a file that will be mounted when the application is deployed and environments (key/value) also generated from a file.

    ```json
      {
        "configmapsfromfile": [
            {
              "name": "datacenters.json",
              "file": "./data/datacenters.json",
              "path": "/data"
            }
        ],
        "envsfromfile": [
            {
              "name": "vgic-env",
              "file": "./data/public.env"
            }
        ]
      }
    ```
    
    `name`: name to give to the configmap
    `file`: path and filename of the file to use
    `path`: mount path to use when deploying the application

  - If a `icce-app-config.json` is found it is processed, it supports creating [service bindings](https://cloud.ibm.com/docs/codeengine?topic=codeengine-service-binding) using the [CE_SERVICES method](https://cloud.ibm.com/docs/codeengine?topic=codeengine-service-binding#ce-services).
    ```json
      {
        "bindings": [
            {
              "serviceName": "vgic-db"
            }
        ]
      }
    ```
    
    `serviceName`: Name of an already provisioned service to bind to. 

## Documentation

- [Examples](docs/examples.md)

## Versioning

For this action you can lock the version to use by specifying it like this: `dprosper/ic-cud-cli@v0.4.0`. 

## License

[Apache Version 2.0](LICENSE)