// Copyright 2023, domohuhn.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:xunit_to_pdf/src/core/system_interactions.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  test('Create and read a file', () {
    var writer = SystemInteractions();
    const path = 'build/moo/out.html';
    const data = 'Some data';
    writer.createPathsAndWriteFile(path, data);
    expect(File(path).existsSync(), true);
    expect(writer.readFile(path), data);
  });

  test('print to terminal - normal', () {
    // more or less a manual test to check if output is visible and no exception is thrown ...
    var writer = SystemInteractions();
    writer.write('write normal -');
    writer.writeLine('writeLine');
  });

  const dir = 'example';
  const dir1 = 'example/data';
  const dir2 = 'example/invalid';

  test('directory exists', () {
    var sys = SystemInteractions();
    expect(sys.directoryExists(dir1), true);
    expect(sys.directoryExists(dir2), false);
  });

  test('file exists', () {
    var sys = SystemInteractions();
    expect(sys.fileExists('$dir1/example1.xml'), true);
    expect(sys.fileExists('$dir2/invalid.xml'), false);
  });

  test('list directory', () {
    var sys = SystemInteractions();
    final list = sys.listDirectoryContents(dir1, false, []);
    list.forEach(print);
    expect(list.length, 5);
  });

  test('list directory with pattern', () {
    var sys = SystemInteractions();
    final list = sys.listDirectoryContents(dir1, false, [RegExp(r'.*\.xml$')]);
    expect(list.length, 4);
  });

  test('list directory recursive with pattern', () {
    var sys = SystemInteractions();
    final list = sys.listDirectoryContents(dir, true, [RegExp(r'.*\.xml$')]);
    expect(list.length, 4);
  });
}
