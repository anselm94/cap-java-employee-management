# Employee Management

A sample Employee Management Portal based on CAP framework.

This project supports both *single-tenancy* as well as *multi-tenancy* in SAP Cloud Platform.

![Domain Modelling](./docs/diagrams/out/domain-modelling.png)

![Use Case Diagram](./docs/diagrams/out/use-case.png)

| Service                                                              | Allowed Roles                    | Description                                                                                                                                                                                                              |
|----------------------------------------------------------------------|----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [`manage-team-service`](./srv/manage-team-service.cds)               | `manager`                        | Create, Update & Delete teams. Also create new positions (members) in a Team and assign Employees                                                                                                                        |
| [`manage-employee-service`](./srv/manage-employee-service.cds)       | `manager`                        | Create, Update & Delete Employees. Also create, update, delete Skills which Employees may have                                                                                                                           |
| [`manage-application-service`](./srv/manage-application-service.cds) | `manager` & `authenticated-user` | For Managers - Create, Update & Delete applications as well as Accept/Reject applications created by Employees For Employees - Create (Apply for a Job) applications for various Teams and add in a Resume as plain-text |
| [`my-profile-service`](./srv/my-profile-service.cds)                 | `authenticated-user`             | Personal Employee details, if the `authenticated-user` has one and optionally add/delete Skills and update DOB                                                                                                           |

## Build & Run

### Prerequisites

* Java 11 or higher (via [SDKMAN!](https://sdkman.io/) preferred)

* Maven 3.5 or higher

* CDS ([install](https://cap.cloud.sap/docs/get-started/#local-setup))

### Build

1. Run *Maven* to compile the project

        mvn clean package

### Run locally

1. Run the Spring Boot application. The `-P cdsdk-global` activates the profile to skip the installation of CDS SDK for every build.

        mvn spring-boot:run -P cdsdk-global

2. Now, the oData API is available at https://localhost:8080

> _Note_: If the compilation fails with `Executable npx not found` error, make sure to delete the `node_modules/` folder from the root of the project.

### Run on Cloud

#### 1. Multi-Target Apps (MTA) Method

##### Prerequisites

* Cloud MTA Builder Tool ([Install](https://sap.github.io/cloud-mta-build-tool/download/))

* Cloud Foundry CLI ([Install](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html))

* Cloud Multiapps CF CLI Plugin ([Install](https://github.com/cloudfoundry-incubator/multiapps-cli-plugin))

* Cloud Foundry CLI logged into the SAP Cloud Foundry account ([Step 1 of tutorial](https://developers.sap.com/tutorials/s4sdk-cloud-foundry-sample-application.html#34579dba-f2c5-48ad-b026-04c40dc269d1))

##### Build & Deploy in the Cloud Foundry

1. Build the MTAR package. Once built, you can find a package named `employee-management_x.y.z.mtar` under *mta_archives/* folder

        mbt build

2. Push the MTAR package and deploy in the Cloud Foundry

        cf deploy mta_archives/employee-management_x.y.z.mtar

## Extending the SaaS application

After subscribing to the application in a separate Sub-account, assign yourself the `Extension_Developer` & `Extension_Admin` roles.

Execute the following to create an extension project in your local

    cds extend https://<DEPLOYED_SUB_ACCOUNT>-<DEPLOYED_SPACE>-employee-management-sidecar.cfapps.sap.hana.ondemand.com/ -d <PROJECT_NAME> -s <SUBSCRIBED_SUB_ACCOUNT>

While logging in, a *passcode* may be asked (if your account is protected by MFA), for which a passcode can be created from `https://<SUBSCRIBED_SUB_ACCOUNT>.authentication.sap.hana.ondemand.com/passcode`. Once authenticated, an extension project will be created locally.

Once created, you can push the changes to your subscribed tenant and activate it by executing the following command

    cds activate --to https://<DEPLOYED_SUB_ACCOUNT>-<DEPLOYED_SPACE>-employee-management-sidecar.cfapps.sap.hana.ondemand.com/ -s <SUBSCRIBED_SUB_ACCOUNT>

More details on SaaS Extensions [here](https://cap.cloud.sap/docs/guides/extensibility).

> See [Dynamic Entity & Service Extension Concept](./docs/dynamic-extensions-concept.md) document for more details on dynamic extensions concept

## License

```txt
MIT License

Copyright (c) 2020 Merbin J Anselm

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```