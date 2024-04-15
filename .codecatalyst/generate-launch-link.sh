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
      parameters: [
        {
          key: "AWS_REGION",
          value: "us-west-2",
          displayType: "dropdown",
          possibleValues: [
            "us-west-1",
            "us-west-2",
            "us-east-1",
            "us-east-2"
          ],
          displayName: "AWS Region",
          description: "AWS Region to deploy the solution to."
        },
        {
          key: "SchedulingActive",
          value: "Yes",
          displayType: "dropdown",
          possibleValues: [
            "Yes",
            "No"
          ],
          displayName: "Scheduling Active",
          description: "Activate or deactivate scheduling."
        },
        {
          key: "ScheduledServices",
          value: "Both",
          displayType: "dropdown",
          possibleValues: [
            "EC2",
            "RDS",
            "Both"
          ],
          displayName: "Scheduled Services",
          description: "Services to schedule."
        },
        {
          key: "ScheduleRdsClusters",
          value: "No",
          displayType: "dropdown",
          possibleValues: [
            "Yes",
            "No"
          ],
          displayName: "Schedule RDS Clusters",
          description: "Enable scheduling of Aurora clusters for RDS service."
        },
        {
          key: "CreateRdsSnapshot",
          value: "No",
          displayType: "dropdown",
          possibleValues: [
            "Yes",
            "No"
          ],
          displayName: "Create RDS Snapshot",
          description: "Create snapshot before stopping RDS instances (does not apply to Aurora Clusters)."
        },
        {
          key: "MemorySize",
          value: "128",
          displayType: "dropdown",
          possibleValues: [
            "128",
            "384",
            "512",
            "640",
            "768",
            "896",
            "1024",
            "1152",
            "1280",
            "1408",
            "1536"
          ],
          displayName: "Memory Size",
          description: "Size of the Lambda function running the scheduler, increase size when processing large numbers of instances."
        },
        {
          key: "UseCloudWatchMetrics",
          value: "No",
          displayType: "dropdown",
          possibleValues: [
            "Yes",
            "No"
          ],
          displayName: "Use CloudWatch Metrics",
          description: "Collect instance scheduling data using CloudWatch metrics."
        },
        {
          key: "LogRetentionDays",
          value: "30",
          displayType: "dropdown",
          possibleValues: [
            "1",
            "3",
            "5",
            "7",
            "14",
            "30",
            "60",
            "90",
            "120",
            "150",
            "180",
            "365",
            "400",
            "545",
            "731",
            "1827",
            "3653"
          ],
          displayName: "Log Retention Days",
          description: "Retention days for scheduler logs."
        },
        {
          key: "Trace",
          value: "No",
          displayType: "dropdown",
          possibleValues: [
            "Yes",
            "No"
          ],
          displayName: "Trace",
          description: "Enable debug-level logging in CloudWatch logs."
        },
        {
          key: "EnableSSMMaintenanceWindows",
          value: "No",
          displayType: "dropdown",
          possibleValues: [
            "Yes",
            "No"
          ],
          displayName: "Enable SSM Maintenance Windows",
          description: "Enable the solution to load SSM Maintenance Windows, so that they can be used for EC2 instance Scheduling."
        },
        {
          key: "DefaultTimezone",
          value: "UTC",
          displayType: "string",
          displayName: "Default Timezone",
          description: "Default timezone to use for scheduling."
        },
        {
          key: "Regions",
          displayType: "string",
          displayName: "Regions",
          description: "List of regions in which instances should be scheduled, leave blank for current region only."
        },
        {
          key: "UsingAWSOrganizations",
          value: "No",
          displayType: "dropdown",
          possibleValues: [
            "Yes",
            "No"
          ],
          displayName: "Using AWS Organizations",
          description: "Use AWS Organizations to automate spoke account registration."
        },
        {
          key: "Principals",
          displayType: "string",
          displayName: "Principals",
          description: "(Required) If using AWS Organizations, provide the Organization ID. Eg. o-xxxxyyy. Else, provide a comma separated list of spoke account ids to schedule. Eg.: 1111111111, 2222222222 or {param: ssm-param-name}" 
        },
        {
          key: "Namespace",
          value: "Default",
          displayType: "string",
          displayName: "Namespace",
          description: "Provide unique identifier to differentiate between multiple solution deployments (No Spaces). Example: Dev"
        },
        {
          key: "SchedulerFrequency",
          value: 5,
          displayType: "number",
          displayName: "Scheduler Frequency",
          description: "Scheduler running frequency in minutes."
        },
      ],
    })
  )
);'