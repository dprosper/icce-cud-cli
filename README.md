# Deploy to IBM Cloud Code Engine

A GitHub action to deploy an application to IBM Cloud Code Engine.

## Usage

```yml
      - name: Deploy to IBM Cloud Code Engine
        uses: dprosper/icce-cud-cli@v0.2.0
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
| `IMAGE` | The name of the image that is used for the application.  | |
| `REGISTRY` | The URL of the registry server. | `https://index.docker.io/v1/` |
| `REGISTRY_USER` | The username to access the registry server. | |
| `REGISTRY_PASSWORD` | The password to access the registry server. | |
| `CE_REGISTRY_SECRET` | The name of the image registry access secret when added to the project. | `registry-secret` |
| `CE_ACTION` | Determines the steps to run in the action, `create`, `update` or `delete`. | |
| `CE_PROJECT_NAME` | The name of the project. Use a name that is unique within the region. | `demo-project` |
| `CE_APP_NAME` | The name of the application. Use a name that is unique within the project. | `demo-app` |

> Note: Only the IBM Cloud official plug-in repository is supported in this action.

## Documentation

- [Examples](docs/examples.md)

## Versioning

For this action you can lock the version to use by specifying it like this: `dprosper/ic-cud-cli@v0.2.0`. 

## License

[Apache Version 2.0](LICENSE)