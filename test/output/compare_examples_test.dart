// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:xunit_to_pdf/src/core/report.dart';
import 'package:xunit_to_pdf/src/core/test_types.dart';
import 'package:xunit_to_pdf/src/output/create_pdf.dart';
import 'package:xunit_to_pdf/src/parse/parse_xunit.dart';
import 'package:xunit_to_pdf/src/core/system_interactions.dart';
import 'package:test/test.dart';

void main() async {
  final reader = SystemInteractions();
  final document1 = reader.readFile('example/data/example1.xml');
  final document2 = reader.readFile('example/data/example2.xml');
  final document3 = reader.readFile('example/data/example3.xml');
  final document4 = reader.readFile('example/data/example4.xml');
  final parsed1 =
      parseXUnit(TestTypes.mutation, 'example/data/example1.xml', document1);
  final parsed2 =
      parseXUnit(TestTypes.unit, 'example/data/example2.xml', document2);
  final parsed3 =
      parseXUnit(TestTypes.unit, 'example/data/example3.xml', document3);
  final parsed4 =
      parseXUnit(TestTypes.unit, 'example/data/example4.xml', document4);

  final data = Report("Test project report", "v1.0.0", DateTime(2023, 1, 1));
  // add parsed 1 multiple times to have more data for the report.
  data.reports.add(parsed1);
  data.reports.add(parsed2);
  data.reports.add(parsed3);
  data.reports.add(parsed4);

  test('Produce example a4', () async {
    var pdf = await generateReport(data, PdfPageFormat.a4);
    final file = File('example/example.pdf');
    // exclude ID TAG
    final comp = file.readAsBytesSync();
    expect(pdf.sublist(0, 76600), comp.sublist(0, 76600));
  });

  test('Produce example letter', () async {
    var pdf = await generateReport(data, PdfPageFormat.letter);
    final file = File('example/example_letter.pdf');
    // exclude ID TAG
    final comp = file.readAsBytesSync();
    expect(pdf.sublist(0, 76600), comp.sublist(0, 76600));
  });
}
