# Orchard Recipe Remote Executor



## About

Orchard module for executing recipes on a remote site through API calls.


## Documentation

This Orchard module lets you execute recipes on a remote Orchard site by providing WebAPI endpoints to send recipes to. Recipes can be run for a the tenant the API is exposed from or from the Default tenant recipes can be run for arbitrary tenants. Multiple recipes can be run in a batch.

See the API endpoints among the module's controllers.

The API needs authentication: use HTTP Basic authorization to authenticate with an Orchard user account (this account needs to have the "Access the Recipe Remote Executor API endpoints" permission). Since there is no encryption only use the API through HTTPS.

Recipe Remote Executor is part of the [Lombiq Hosting Suite](http://dotnest.com/knowledge-base/topics/lombiq-hosting-suite), a suite of modules making Orchard able to scale better, more fault-tolerant, and have improved maintainability.


## Contributing and support

Bug reports, feature requests, comments, questions, code contributions, and love letters are warmly welcome, please do so via GitHub issues and pull requests. Please adhere to our [open-source guidelines](https://lombiq.com/open-source-guidelines) while doing so.

This project is developed by [Lombiq Technologies](https://lombiq.com/). Commercial-grade support is available through Lombiq.