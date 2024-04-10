// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: Apache-2.0

import * as ec2 from "@aws-sdk/client-ec2";

import { delayMinutes } from "./index";
import { getInstanceState } from "./utils/ec2-test-utils";
import { createSchedule, currentTimePlus, toTimeStr } from "./utils/schedule-test-utils";
import { CfnStackResourceFinder } from "./utils/cfn-utils";

const ec2Client = new ec2.EC2Client({});
let instanceId: string;
const startStopTestScheduleName = "ec2_basic_start_stop_test_schedule";

beforeAll(async () => {
  const cfnStackResourceFinder = await CfnStackResourceFinder.fromStackName("instance-scheduler-on-aws-end-to-end-testing-resources");
  instanceId = cfnStackResourceFinder.findResourceByPartialId("basicstartstopinstance")?.PhysicalResourceId!;
});

test("instanceId exists", () => {
  expect(instanceId).not.toBeUndefined();
});
test("basic ec2 start-stop schedule", async () => {
  //stop instance
  await ec2Client.send(
    new ec2.StopInstancesCommand({
      InstanceIds: [instanceId],
    }),
  );

  //confirm stopped
  await delayMinutes(1);
  expect(await getInstanceState(ec2Client, instanceId)).toBe(ec2.InstanceStateName.stopped);

  //create schedule
  await createSchedule({
    name: startStopTestScheduleName,
    description: `testing schedule`,
    periods: [
      {
        name: "ec2-start-stop-period",
        description: `testing period`,
        begintime: toTimeStr(currentTimePlus(3)),
        endtime: toTimeStr(currentTimePlus(7)),
      },
    ],
  });

  //confirm running during running period
  await delayMinutes(5);
  expect(await getInstanceState(ec2Client, instanceId)).toBe(ec2.InstanceStateName.running);

  //confirm stopped after stop time
  await delayMinutes(5);
  expect(await getInstanceState(ec2Client, instanceId)).toBe(ec2.InstanceStateName.stopped);
}, 900_000);
