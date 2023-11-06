// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:xunit_to_pdf/src/core/test_types.dart';
import 'package:xunit_to_pdf/src/parse/parse_xunit.dart';
import 'package:xunit_to_pdf/src/core/system_interactions.dart';
import 'package:test/test.dart';
import 'package:xunit_to_pdf/src/core/test_result.dart';

void main() {
  group('Successful parse example1', () {
    final reader = SystemInteractions();
    final document = reader.readFile('example/data/example1.xml');
    final parsed =
        parseXUnit(TestTypes.unit, 'example/data/example1.xml', document);

    test('Number of test suites', () {
      expect(parsed.testSuites.length, 20);
      expect(parsed.suites, 20);
    });

    test('type', () {
      expect(parsed.type, TestTypes.unit);
    });

    test('number of tests', () {
      expect(parsed.tests, 72);
    });

    test('number of passed tests', () {
      expect(parsed.passed, 24);
    });

    test('number of failed tests', () {
      expect(parsed.failures, 24);
    });

    test('number of errors', () {
      expect(parsed.errors, 24);
    });

    test('total runtime', () {
      expect(parsed.runtime, Duration(milliseconds: 4212));
    });

    test('Parse passed', () {
      parsed.testSuites.first.forEach(TestResult.passed, (p) {
        expect(p.name.isNotEmpty, true);
        expect(p.suite.isNotEmpty, true);
        expect(p.result, TestResult.passed);
        expect(p.information == null, true);
      });
    });

    test('Parsing failures', () {
      parsed.testSuites.first.forEach(TestResult.failure, (p) {
        expect(p.name.isNotEmpty, true);
        expect(p.suite.isNotEmpty, true);
        expect(p.result, TestResult.failure);
        expect(p.information != null, true);
        expect(p.information!.type, 'undetected');
        expect(p.information!.message,
            'All tests passed despite changing the code!');
        final reg = RegExp(
            r'^File: .*?\nLine: .*?\nOriginal line: .*?\nMutation: .*$',
            multiLine: true);
        expect(reg.hasMatch(p.information!.text!), true);
      });
    });

    test('Parse errors', () {
      parsed.testSuites.first.forEach(TestResult.error, (p) {
        expect(p.name.isNotEmpty, true);
        expect(p.suite.isNotEmpty, true);
        expect(p.result, TestResult.error);
        expect(p.information != null, true);
        expect(p.information!.type, 'timeout');
        expect(
            p.information!.message, 'The test command timed out after 0.0 s');
        final reg = RegExp(
            r'^File: .*?\nLine: .*?\nOriginal line: .*?\nMutation: .*$',
            multiLine: true);
        expect(reg.hasMatch(p.information!.text!), true);
      });
    });
  });

  group('Successful parse example2', () {
    final reader = SystemInteractions();
    final document = reader.readFile('example/data/example2.xml');
    final parsed =
        parseXUnit(TestTypes.unit, 'example/data/example2.xml', document);

    test('Number of test suites', () {
      expect(parsed.testSuites.length, 3);
      expect(parsed.suites, 3);
    });

    test('type', () {
      expect(parsed.type, TestTypes.unit);
    });

    test('number of tests', () {
      expect(parsed.tests, 42);
    });

    test('number of passed tests', () {
      expect(parsed.passed, 42);
    });

    test('number of failed tests', () {
      expect(parsed.failures, 0);
    });

    test('number of errors', () {
      expect(parsed.errors, 0);
    });

    test('total runtime', () {
      expect(parsed.runtime, Duration(milliseconds: 1));
    });

    test('Parse passed', () {
      parsed.testSuites.first.forEach(TestResult.passed, (p) {
        expect(p.name.isNotEmpty, true);
        expect(p.suite.isNotEmpty, true);
        expect(p.result, TestResult.passed);
        expect(p.information == null, true);
      });
    });
  });
}
