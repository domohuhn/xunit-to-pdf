// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

/// Types of tests recognized by the writer
enum TestTypes {
  unit,
  integration,
  qualification,
  functional,
  system,
  mutation,
  endToEnd,
  performance,
  smoke,
  acceptance,
  fuzz,
  custom
}

String _testTypeToReportString(TestTypes t) {
  switch (t) {
    case TestTypes.unit:
      return "Unit";
    case TestTypes.integration:
      return "Integration";
    case TestTypes.qualification:
      return "Qualification";
    case TestTypes.functional:
      return "Functional";
    case TestTypes.system:
      return "System";
    case TestTypes.mutation:
      return "Mutation";
    case TestTypes.endToEnd:
      return "End-to-end";
    case TestTypes.performance:
      return "Performance";
    case TestTypes.smoke:
      return "Smoke";
    case TestTypes.acceptance:
      return "Acceptance";
    case TestTypes.fuzz:
      return "Fuzz";
    case TestTypes.custom:
      return "Custom";
  }
}

String testTypeToReportString(TestTypes t) {
  return "${_testTypeToReportString(t)} Tests";
}

const List<TestTypes> testTypeList = [
  TestTypes.unit,
  TestTypes.integration,
  TestTypes.qualification,
  TestTypes.functional,
  TestTypes.system,
  TestTypes.endToEnd,
  TestTypes.performance,
  TestTypes.smoke,
  TestTypes.acceptance,
  TestTypes.fuzz,
  TestTypes.mutation,
  TestTypes.custom
];
