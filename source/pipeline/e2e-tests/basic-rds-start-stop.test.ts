// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0
import * as rds from "@aws-sdk/client-rds";

import { delayMinutes } from "./index";
import { getInstanceState } from "./utils/rds-test-utils";
import { createSchedule, currentTimePlus, toTimeStr } from "./utils/schedule-test-utils";
import { CfnStackResourceFinder } from "./utils/cfn-utils";

const rdsClient = new rds.RDSClient({});
let rdsInstanceId: string;
const taggedScheduleName = "rds_basic_start_stop_test_schedule";

beforeAll(async () => {
  const cfnStackResourceFinder = await CfnStackResourceFinder.fromStackName("instance-scheduler-on-aws-end-to-end-testing-resources");
  rdsInstanceId = cfnStackResourceFinder.findResourceByPartialId("rdsbasicstartstop")?.PhysicalResourceId!;
});

test("rdsInstanceAccessible", async () => {
  const fetchResult = await rdsClient.send(
    new rds.DescribeDBInstancesCommand({
      DBInstanceIdentifier: rdsInstanceId,
    }),
  );

  expect(fetchResult.DBInstances?.[0]).not.toBeUndefined();
});

test("basic rds start-stop schedule", async () => {
  const preTestState = await getInstanceState(rdsClient, rdsInstanceId);
  if (!["stopped", "stopping"].includes(preTestState)) {
    console.log(`instance in state ${preTestState} before test. Attempting to stop before running test...`);
    await rdsClient.send(
      new rds.StopDBInstanceCommand({
        DBInstanceIdentifier: rdsInstanceId,
      }),
    );
    await delayMinutes(5);
  }

  //create test schedule
  await createSchedule({
    name: taggedScheduleName,
    description: `testing schedule`,
    periods: [
      {
        name: "rds-start-stop-period",
        description: `testing period`,
        begintime: toTimeStr(currentTimePlus(3)),
        endtime: toTimeStr(currentTimePlus(7)),
      },
    ],
  });

  //confirm running during running period
  await delayMinutes(5);
  expect(await getInstanceState(rdsClient, rdsInstanceId)).toBeOneOf(["available", "starting"]);

  //confirm stopped after stop time
  await delayMinutes(4);
  expect(await getInstanceState(rdsClient, rdsInstanceId)).toBeOneOf(["stopped", "stopping"]);
}, 1_200_000);
