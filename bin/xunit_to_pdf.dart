// Copyright 2023, domohuhn
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:xunit_to_pdf/src/core/test_types.dart';
import 'package:xunit_to_pdf/xunit_to_pdf.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser();

  const help = 'help';
  const output = 'output';
  const title = 'title';
  const version = 'version';

  const List<(String, String?, TestTypes)> inputs = [
    ('unit-test', 'u', TestTypes.unit),
    ('integration-test', 'i', TestTypes.integration),
    ('qualification-test', 'q', TestTypes.qualification),
    ('functional-test', null, TestTypes.functional),
    ('system-test', 's', TestTypes.system),
    ('mutation-test', 'm', TestTypes.mutation),
    ('end-to-end-test', 'e', TestTypes.endToEnd),
    ('performance-test', 'p', TestTypes.performance),
    ('smoke-test', null, TestTypes.smoke),
    ('acceptance-test', 'a', TestTypes.acceptance),
    ('fuzz-test', 'f', TestTypes.fuzz),
    ('custom-test', 'c', TestTypes.custom)
  ];

  parser.addFlag(help,
      abbr: 'h', negatable: false, help: 'Prints this help message');
  parser.addOption(output,
      abbr: 'o',
      help: 'The output filename',
      valueHelp: 'filename',
      defaultsTo: 'report.pdf');
  parser.addOption(title,
      abbr: 't',
      help: 'Title of the report',
      valueHelp: 'title',
      defaultsTo: 'Test report');
  parser.addOption(version,
      abbr: 'v',
      help: 'Project version',
      valueHelp: 'version',
      defaultsTo: 'n/a');
  for (final opt in inputs) {
    parser.addMultiOption(opt.$1,
        abbr: opt.$2, help: 'A ${opt.$1} report', valueHelp: 'path to xunit');
  }

  final options = parser.parse(arguments);

  if (options[help]) {
    print("A program to convert xunit reports into a pdf.");
    print(parser.usage);
    exit(0);
  }

  final converter =
      ConversionContext(title: options[title], version: options[version]);

  for (final opt in inputs) {
    if (options.wasParsed(opt.$1)) {
      for (final doc in options[opt.$1]) {
        converter.addInput(opt.$3, doc);
      }
    }
  }

  converter.convertXunitToPdf(options[output]);
}
