// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:xunit_to_pdf/src/core/test_case.dart';
import 'package:xunit_to_pdf/src/core/test_result.dart';

/// A test suite from a xunit document.
class TestSuite {
  TestSuite(this.name, this.runtime, this.timeStamp);

  /// Name of the test suite.
  String name;

  /// Time it took to run the test suite. Required.
  Duration runtime;

  /// When the test suite was executed.
  DateTime timeStamp;

  int get tests => testCases.length;
  int get passed => _countTestCasesByType(TestResult.passed);
  int get failures => _countTestCasesByType(TestResult.failure);
  int get errors => _countTestCasesByType(TestResult.error);

  int _countTestCasesByType(TestResult type) {
    int count = 0;
    for (var element in testCases) {
      if (element.result == type) {
        count += 1;
      }
    }
    return count;
  }

  List<TestCase> testCases = [];

  void forEach(TestResult type, void Function(TestCase) fun) {
    for (var element in testCases) {
      if (element.result == type) {
        fun(element);
      }
    }
  }
}
