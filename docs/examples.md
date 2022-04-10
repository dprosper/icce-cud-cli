

* [Code Engine](https://github.com/dprosper/cidr-calculator/tree/main/.github/workflows): An example workflow that uses GitHub Actions to deploy from source
code to [Code Engine](https://cloud.ibm.com/codeengine), a fully managed serverless platform.


#### Create a project in Code Engine workflow

This example will create a project in Code Engine and deploy an app naming the project/app based on the pull request sha. The action takes additional input from a `json` file located in the same directory as the workflow file.  If a the `icce-project-config.json` is found it is processed, currently it supports creating confirmaps only.  

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
```

![](./docs/assets/icce-cud-create-running.png)


![](./docs/assets/icce-cud-create-success.png)



#### Delete a project in Code Engine workflow

This example will delete a project in Code Engine.  On delete failures it will create a comment inside the PR and it will generate an issue.  

```yml
      - name: Delete from IBM Cloud Code Engine
        uses: dprosper/icce-cud-cli@v0.2.0
        with:
          ISSUE_NUMBER: ${{ github.event.pull_request.number }}
          CE_PROJECT_NAME: project-${{ github.event.pull_request.head.sha }}
          CE_ACTION: delete
```
![](./docs/assets/icce-cud-delete-update-success.png)


#### Update a project in Code Engine workflow

This example will update a project in Code Engine.  On update failures it will create a comment inside the PR and it will generate an issue.  

```yml
      - name: Update in IBM Cloud Code Engine
        uses: dprosper/icce-cud-cli@v0.2.0
        with:
          CE_PROJECT_NAME: project-production
          CE_APP_NAME: app-production
          IMAGE: ${{ env.REGISTRY_ORG_NAMESPACE }}/${{ env.REGISTRY_REPOSITORY }}:latest
          CE_ACTION: update
```

![](./docs/assets/icce-cud-delete-update-failed.png)
