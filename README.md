# Actions DE Demo V3

This repository contains a sample Data Engineering project that can be deployed using GitHub Actions.

See `requirements.md` for the full details of the demo.

## Setup

For the demos to execute, we need to set up the following:

1. Set up OpenID Connect (OIDC) between GitHub and Azure (see https://github.com/Azure/login?tab=readme-ov-file#login-with-openid-connect-oidc-recommended) for *every* environment you need to (create)
   * Give the app registration enough rights to create and the manage resource groups in the scope you want/need
2. Create a storage account for the backend store for the statefile
   * Give the app registration storage blob contributor rights
3. Inside GitHub, add the following secrets per environment:
   * AZURE_CLIENT_ID
   * AZURE_SUBSCRIPTION_ID
   * AZURE_TENANT_ID
4. Inside GitHub, add the following variables per environment:
   * LOCATION (for example `westeurope`)
   * RESOURCE_GROUP

