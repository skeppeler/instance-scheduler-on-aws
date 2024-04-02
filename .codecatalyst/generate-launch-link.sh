#!/bin/bash
node -e 'console.log(
  "https://codecatalyst.aws/launch?options=" + 
  encodeURIComponent(
    JSON.stringify({
      sourceRepository: "https://github.com/aws-khargita/instance-scheduler-on-aws",
      destinationRepositoryName: "instance-scheduler-on-aws",
      environments: [{
        name: "development",
        environmentType: "Non-production"
      }],
      options: [
        ["region", "us-west-2"]
      ],
    })
  )
);'