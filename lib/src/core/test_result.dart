// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:xunit_to_pdf/src/core/parse_error.dart';

/// Status of a test case
enum TestResult {
  /// Test completed
  passed,

  /// Test completed and checks failed
  failure,

  /// There was an error during the execution of the test that is related to the test runner, e.g. a timeout.
  /// The test did not complete
  error
}

TestResult fromString(String s) {
  switch (s) {
    case 'passed':
      return TestResult.passed;
    case 'failure':
      return TestResult.failure;
    case 'error':
      return TestResult.error;
    default:
      throw ParseError('Unknown test result "$s"');
  }
}
