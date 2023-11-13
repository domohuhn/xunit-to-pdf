// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:xunit_to_pdf/src/core/report.dart';
import 'package:pdf/pdf.dart';

import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:xunit_to_pdf/src/core/test_result.dart';
import 'package:xunit_to_pdf/src/core/test_suite.dart';
import 'package:xunit_to_pdf/src/core/test_types.dart';
import 'package:xunit_to_pdf/src/output/colors.dart';
import 'package:xunit_to_pdf/src/output/list_element.dart';
import 'package:xunit_to_pdf/src/output/page.dart';
import 'package:xunit_to_pdf/src/output/pie_chart.dart';

pw.Container _createInfoBoxes(dynamic data) {
  return pw.Container(
      child: pw.Row(children: [
        _NumberDisplay(title: 'Tests: ${data.tests}', color: baseColor),
        _NumberDisplay(title: 'Passed: ${data.passed}', color: baseColor),
        _NumberDisplay(title: 'Failed: ${data.failures}', color: baseColor),
        _NumberDisplay(title: 'Blocked: ${data.errors}', color: baseColor)
      ]),
      height: 50);
}

pw.Container _createInfoBoxesByType(dynamic data, TestTypes type) {
  return pw.Container(
      child: pw.Row(children: [
        _NumberDisplay(
            title: 'Tests: ${data.testsByType(type)}', color: baseColor),
        _NumberDisplay(
            title: 'Passed: ${data.passedByType(type)}', color: baseColor),
        _NumberDisplay(
            title: 'Failed: ${data.failuresByType(type)}', color: baseColor),
        _NumberDisplay(
            title: 'Blocked: ${data.errorsByType(type)}', color: baseColor)
      ]),
      height: 50);
}

pw.Column _createTestSuiteInfoText(
    String title, String filename, dynamic suite) {
  return pw.Column(
      children: [
        _createInfoBoxes(suite),
        pw.Container(
            alignment: pw.Alignment.centerLeft,
            height: 60,
            padding: pw.EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: pw.Column(children: [
              pw.Text("Part of:        $title",
                  softWrap: true, textAlign: pw.TextAlign.left),
              pw.Text("File:             $filename",
                  softWrap: true, textAlign: pw.TextAlign.left),
              pw.Text("Timestamp: ${suite.timeStamp}",
                  softWrap: true, textAlign: pw.TextAlign.left),
              pw.Text("Duration:     ${suite.runtime}",
                  softWrap: true, textAlign: pw.TextAlign.left),
            ], crossAxisAlignment: pw.CrossAxisAlignment.start))
      ],
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start);
}

pw.Column _createReportInfoText(String title, String filename, dynamic data) {
  return pw.Column(
      children: [
        _createInfoBoxes(data),
        pw.Container(
            alignment: pw.Alignment.centerLeft,
            height: 70,
            padding: pw.EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: pw.Column(children: [
              pw.Text("Report created:   ${data.timestamp}",
                  softWrap: true, textAlign: pw.TextAlign.left),
              pw.Text("Version:               ${data.version}",
                  softWrap: true, textAlign: pw.TextAlign.left),
              pw.Text("Duration:             ${data.runtime}",
                  softWrap: true, textAlign: pw.TextAlign.left),
              pw.Text("Test documents: ${data.documents}",
                  softWrap: true, textAlign: pw.TextAlign.left),
              pw.Text("Test suites:         ${data.suites}",
                  softWrap: true, textAlign: pw.TextAlign.left)
            ], crossAxisAlignment: pw.CrossAxisAlignment.start))
      ],
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start);
}

pw.Row _createInfoRow(String title, String filename, dynamic data,
    pw.Column Function(String, String, dynamic) fun,
    [pw.Chart Function(dynamic, dynamic) chart = createResultsPieChart,
    TestTypes type = TestTypes.unit]) {
  const double size = 120;
  return pw.Row(mainAxisSize: pw.MainAxisSize.max, children: [
    pw.Container(width: size, height: size, child: chart(data, type)),
    fun(title, filename, data)
  ]);
}

class _NumberDisplay extends pw.StatelessWidget {
  _NumberDisplay({required this.title, required this.color});

  final String title;
  final PdfColor color;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: color,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      margin: const pw.EdgeInsets.fromLTRB(5, 0, 5, 5),
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        title,
        textScaleFactor: 1.0,
      ),
    );
  }
}

/// Generates the report page for a test [suite] parsed from [filename].
///
/// A page comprises a title, an info box with a pie chart and the [testType].
/// A list of test cases as bullet points is added below.
///
/// [pageFormat] determines the dimensions of the page in the pdf document.
pw.Page generateTestSuiteReport(Report data, String testType, String filename,
    TestSuite suite, PdfPageFormat pageFormat) {
  final theme = pw.ThemeData.base();
  final childList = <pw.Widget>[
    pw.Column(children: [
      pw.Text('Test suite "${suite.name}"',
          style: const pw.TextStyle(
            color: textBaseColor,
            fontSize: 20,
          )),
      pw.Divider(thickness: 2),
      _createInfoRow(testType, filename, suite, _createTestSuiteInfoText),
      pw.Divider()
    ])
  ];

  for (final test in suite.testCases) {
    switch (test.result) {
      case TestResult.passed:
        childList.add(BulletPoint(
            text: "Passed: ${test.suite}.${test.name}", color: colorPassed));
      case TestResult.failure:
        childList.add(BulletPointAndTextBlock(
            text: "Failed: ${test.suite}.${test.name}",
            block: test.information,
            color: colorFailed));
      case TestResult.error:
        childList.add(BulletPointAndTextBlock(
            text: "Blocked: ${test.suite}.${test.name}",
            block: test.information,
            color: colorError));
    }
  }

  return createPage(data, theme, pageFormat, childList);
}

/// Generates the title page of the report.
///
/// The page comprises a title, an info box with a pie chart and
/// a list of test types with all test suites listed as bullet points.
/// At the bottom of the page is a footer with the title, version and date.
///
/// [pageFormat] determines the dimensions of the page in the pdf document.
pw.Page generateTitlePage(Report data, PdfPageFormat pageFormat) {
  final theme = pw.ThemeData.base();
  final childList = <pw.Widget>[
    pw.Column(children: [
      pw.Text(data.title,
          style: const pw.TextStyle(
            color: textBaseColor,
            fontSize: 20,
          )),
      pw.Text("Overview",
          style: const pw.TextStyle(
            color: textBaseColor,
            fontSize: 20,
          )),
      pw.Divider(thickness: 2),
      _createInfoRow(data.title, '', data, _createReportInfoText),
      pw.Divider(),
    ])
  ];
  for (final type in testTypeList) {
    bool typeAdded = false;
    for (final doc in data.reports) {
      if (doc.type != type) {
        continue;
      }
      if (!typeAdded) {
        childList.add(Heading(title: testTypeToReportString(type)));
        typeAdded = true;
      }
      childList.add(BulletPointTextAndFraction(
          text: doc.filename, passed: doc.passed, total: doc.tests));
    }
  }
  return createPage(data, theme, pageFormat, childList);
}

/// Generates the overview page for a test [type] (e.g. Unit tests).
///
/// A page comprises a title, an info box with a pie chart and
/// a list of test suites as bullet points.
/// At the bottom of the page is a footer with the title, version and date.
///
/// [pageFormat] determines the dimensions of the page in the pdf document.
pw.Page generateTestTypePage(
    Report data, TestTypes type, PdfPageFormat pageFormat) {
  final theme = pw.ThemeData.base();
  final childList = <pw.Widget>[
    pw.Column(children: [
      pw.Text(testTypeToReportString(type),
          style: const pw.TextStyle(
            color: textBaseColor,
            fontSize: 20,
          )),
      pw.Divider(thickness: 2),
      _createInfoRow(testTypeToReportString(type), '', data,
          (title, filename, data) {
        return pw.Column(
            children: [
              _createInfoBoxesByType(data, type),
              pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  height: 60,
                  padding: pw.EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: pw.Column(children: [
                    pw.Text("Part of:        $title",
                        softWrap: true, textAlign: pw.TextAlign.left),
                  ], crossAxisAlignment: pw.CrossAxisAlignment.start))
            ],
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start);
      }, createResultsByTypePieChart, type),
      pw.Divider(),
    ])
  ];
  for (final doc in data.reports) {
    if (doc.type != type) {
      continue;
    }
    childList.add(BulletPointTextAndFraction(
        text: doc.filename, passed: doc.passed, total: doc.tests));
  }
  return createPage(data, theme, pageFormat, childList);
}

/// Creates a pdf file from the report [data] using the given [pageFormat].
///
/// The return value contains the binary representation of the pdf document.
/// You can write every byte of the returned list to disk to save the pdf document
/// for later.
Future<Uint8List> generateReport(Report data, PdfPageFormat pageFormat) async {
  final document = pw.Document();

  document.addPage(generateTitlePage(data, pageFormat));

  for (final type in testTypeList) {
    if (data.testsByType(type) == 0) {
      continue;
    }
    document.addPage(generateTestTypePage(data, type, pageFormat));
    for (final test in data.reports) {
      for (final suite in test.testSuites) {
        if (type == test.type) {
          document.addPage(generateTestSuiteReport(
              data,
              testTypeToReportString(test.type),
              test.filename,
              suite,
              pageFormat));
        }
      }
    }
  }
  return document.save();
}
