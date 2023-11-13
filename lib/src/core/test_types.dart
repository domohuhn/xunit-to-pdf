// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

/// Types of tests recognized by the writer
enum TestTypes {
  /// unit-tests. Typically the most specific test cases.
  unit,

  /// integration-tests. Uses multiple units or components.
  integration,

  /// qualification-tests. verifies that the project requirements are met.
  /// Uses the actual binary of the software.
  qualification,
  functional,

  /// System tests. Verifies that the the whole system (hardware and software)
  /// works.
  system,

  /// Verifies that random mutations of the software are detected.
  mutation,
  endToEnd,

  /// Tests the performance of the software.
  performance,
  smoke,
  acceptance,

  /// Verifies that the software can handle random inputs.
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

/// A list of all test types to iterate
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
