// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:xunit_to_pdf/src/core/test_result.dart';

/// Holds the information about a test case.
class TestCase {
  /// The name of the test case. Required.
  String name;

  /// Test suite. Required.
  String suite;

  /// Time it took to run the test. Required.
  Duration runtime;

  /// The result of the test execution. Required.
  TestResult result;

  /// Additional information describing what happened during the
  /// test case. Usually only available for failures or errors.
  OptionalInformation? information;

  TestCase(this.name, this.suite, this.runtime, this.result,
      {this.information});
}

/// Optional information for errors or failures
class OptionalInformation {
  /// what kind of test failure or error
  String type;

  /// the message from the test runner
  String message;

  /// additional text or system output
  String? text;

  OptionalInformation(this.type, this.message, this.text);
}
