// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:xunit_to_pdf/src/core/test_suite.dart';
import 'package:xunit_to_pdf/src/core/test_types.dart';

/// A data structure describing an xunit document.
class XUnitDocument {
  /// The type of the document
  TestTypes type;

  /// The name of the document
  String filename;

  List<TestSuite> testSuites = [];

  XUnitDocument(this.type, this.filename);

  int get suites => testSuites.length;
  int get tests => _countCases((s) => s.tests);
  int get passed => _countCases((s) => s.passed);
  int get failures => _countCases((s) => s.failures);
  int get errors => _countCases((s) => s.errors);
  Duration get runtime {
    Duration duration = Duration(milliseconds: 0);
    for (final suite in testSuites) {
      duration += suite.runtime;
    }
    return duration;
  }

  int _countCases(int Function(TestSuite) fun) {
    int count = 0;
    for (final suite in testSuites) {
      count += fun(suite);
    }
    return count;
  }
}
