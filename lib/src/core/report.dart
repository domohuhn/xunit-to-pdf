// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:xunit_to_pdf/src/core/test_types.dart';
import 'package:xunit_to_pdf/xunit_to_pdf.dart';

/// A report for test runs
class Report {
  String title;
  String version;
  DateTime timestamp;
  List<XUnitDocument> reports = [];

  Report(this.title, this.version, this.timestamp);

  int get documents => reports.length;
  int get suites => _countCases((s) => s.suites);
  int get tests => _countCases((s) => s.tests);
  int get passed => _countCases((s) => s.passed);
  int get failures => _countCases((s) => s.failures);
  int get errors => _countCases((s) => s.errors);
  Duration get runtime {
    Duration duration = Duration(milliseconds: 0);
    for (final rep in reports) {
      duration += rep.runtime;
    }
    return duration;
  }

  int _countCases(int Function(XUnitDocument) fun,
      [bool any = true, TestTypes type = TestTypes.unit]) {
    int count = 0;
    for (final doc in reports) {
      if (any || doc.type == type) {
        count += fun(doc);
      }
    }
    return count;
  }

  int testsByType(TestTypes t) => _countCases((s) => s.tests, false, t);
  int passedByType(TestTypes t) => _countCases((s) => s.passed, false, t);
  int failuresByType(TestTypes t) => _countCases((s) => s.failures, false, t);
  int errorsByType(TestTypes t) => _countCases((s) => s.errors, false, t);
}
