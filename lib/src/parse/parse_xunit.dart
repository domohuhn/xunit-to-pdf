// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'package:xml/xml.dart' as xml;
import 'package:xunit_to_pdf/src/core/parse_error.dart';
import 'package:xunit_to_pdf/src/core/test_case.dart';
import 'package:xunit_to_pdf/src/core/test_result.dart';
import 'package:xunit_to_pdf/src/core/test_suite.dart';
import 'package:xunit_to_pdf/src/core/test_types.dart';
import 'package:xunit_to_pdf/src/core/xunit_document.dart';

/// Converts the given [document] to the XUnitDocument data structure.
/// The contents of the string [document] must be a valid xunit or junit
/// xml document.
/// There is no "official" schema to create a conforming xml document.
/// However, there are a unofficial ones on github, e.g.
/// http://windyroad.com.au/dl/Open%20Source/JUnit.xsd
/// or
/// https://gist.github.com/jclosure/45d7005d120d90ba6430130356e4cd61
/// or check output from google test and ctest.
///
/// Both of the these schemas should be compatible with tools such as
/// Polarion.
///
/// This parser will only use the common elements of these example documents
/// so that it is useable for a wide range of tools that create these types
/// of reports.
///
/// [type] is the type of the parsed tests. It is used to categorize the
/// results in the combined report.
/// [filename] should be the file name from which the contents of [document] were read.
///
XUnitDocument parseXUnit(TestTypes type, String filename, String document) {
  final contents = xml.XmlDocument.parse(document);
  var parsed = XUnitDocument(type, filename);
  for (final element in contents.findAllElements('testsuite')) {
    parsed.testSuites.add(_parseTestSuite(element));
  }
  return parsed;
}

TestSuite _parseTestSuite(xml.XmlElement root) {
  // name of the test suite - a string
  final name = _getRequiredAttribute(root, 'test suite', 'name');
  final runtime = _getRuntime(root, 'test suite');
  // timestamp in the format YYYY-MM-DDThh:mm:ss
  final timestampStr = _getRequiredAttribute(root, 'test suite', 'timestamp');
  final DateTime timestamp = DateTime.parse(timestampStr);
  TestSuite suite = TestSuite(name, runtime, timestamp);

  for (final current in root.findElements('testcase')) {
    suite.testCases.add(_parseTestCase(current));
  }
  return suite;
}

TestCase _parseTestCase(xml.XmlElement node) {
  final name = _getRequiredAttribute(node, 'test case', 'name');
  final suite = _getRequiredAttribute(node, 'test case', 'classname');
  final runtime = _getRuntime(node, 'test suite');
  final (result, info) = _getResult(node);
  return TestCase(name, suite, runtime, result, information: info);
}

String _getRequiredAttribute(
    xml.XmlElement node, String nodeType, String attribute) {
  final parsed = node.getAttribute(attribute);
  if (parsed == null) {
    throw ParseError(
        'A $nodeType must have "$attribute" as attribute!\nGot "$node"');
  }
  return parsed;
}

Duration _getRuntime(xml.XmlElement node, String nodeType) {
  // time in seconds, usually a double with 3 decimals: e.g. 1.234 for 1234 ms
  final timeStr = _getRequiredAttribute(node, nodeType, 'time');
  final convertedMs = 1000 * double.parse(timeStr);
  return Duration(milliseconds: convertedMs.round());
}

(TestResult, OptionalInformation?) _getResult(xml.XmlElement node) {
  final resultTypes = ['failure', 'error'];
  for (final result in resultTypes) {
    for (final current in node.findElements(result)) {
      String type = _getRequiredAttribute(current, result, 'type');
      String message = _getRequiredAttribute(current, result, 'message');
      return (
        fromString(result),
        OptionalInformation(type, message, current.innerText)
      );
    }
  }
  return (TestResult.passed, null);
}
