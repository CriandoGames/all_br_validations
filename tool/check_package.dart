import 'dart:io';

final errors = <String>[];

void fail(String message) => errors.add(message);

Iterable<File> dartFiles(Directory directory) sync* {
  if (!directory.existsSync()) return;
  for (final entity
      in directory.listSync(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      yield entity;
    }
  }
}

String relative(File file, Directory root) =>
    file.path.substring(root.path.length + 1).replaceAll('\\', '/');

void main() {
  final root = File.fromUri(Platform.script).parent.parent;
  final pubspecFile = File('${root.path}${Platform.pathSeparator}pubspec.yaml');
  final pubspec = pubspecFile.readAsStringSync();
  final packageName = RegExp(r'^name:\s*([a-z0-9_]+)\s*$', multiLine: true)
      .firstMatch(pubspec)
      ?.group(1);

  if (packageName == null) {
    fail('pubspec.yaml não declara um nome de pacote válido.');
  }
  if (RegExp(r'^\s+path:\s+', multiLine: true).hasMatch(pubspec)) {
    fail('pubspec.yaml publicável contém dependência path.');
  }
  if (pubspec.contains('package:flutter/') ||
      RegExp(r'^\s+flutter:\s*$', multiLine: true).hasMatch(pubspec)) {
    fail('Pacote Dart puro depende de Flutter.');
  }

  const requiredFiles = <String>[
    'README.md',
    'README.en.md',
    'CHANGELOG.md',
    'CHANGELOG.en.md',
    'CONTRIBUTING.md',
    'CONTRIBUTING.en.md',
    'SECURITY.md',
    'SECURITY.en.md',
    'LICENSE',
    'analysis_options.yaml',
    '.pubignore',
    'documentation/images/hero.png',
  ];
  for (final path in requiredFiles) {
    if (!File('${root.path}${Platform.pathSeparator}$path').existsSync()) {
      fail('Documento/arquivo obrigatório ausente: $path.');
    }
  }

  for (final locale in ['pt-BR', 'en']) {
    final directory = Directory(
      '${root.path}${Platform.pathSeparator}doc'
      '${Platform.pathSeparator}$locale',
    );
    if (!directory.existsSync() ||
        directory
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.md'))
            .isEmpty) {
      fail('Documentação $locale ausente ou vazia.');
    }
  }

  final example = Directory(
    '${root.path}${Platform.pathSeparator}example',
  );
  if (!example.existsSync() || dartFiles(example).isEmpty) {
    fail('Exemplo Dart obrigatório ausente.');
  }
  final tests = Directory('${root.path}${Platform.pathSeparator}test');
  if (!tests.existsSync() ||
      dartFiles(tests)
          .where((file) => file.path.endsWith('_test.dart'))
          .isEmpty) {
    fail('Testes obrigatórios ausentes.');
  }

  final lib = Directory('${root.path}${Platform.pathSeparator}lib');
  final uriPattern = RegExp(r'''(?:import|export|part)\s+['"]([^'"]+)['"]''');
  for (final file in dartFiles(lib)) {
    final source = file.readAsStringSync();
    final name = relative(file, root);
    if (source.contains('package:all_validations_br/')) {
      fail('$name importa o agregador.');
    }
    for (final token in [
      'package:flutter/',
      'TextInputFormatter',
      'TextEditingValue',
      'BuildContext',
      'Widget',
    ]) {
      if (source.contains(token)) {
        fail('$name contém referência Flutter: $token.');
      }
    }

    for (final match in uriPattern.allMatches(source)) {
      final uri = match.group(1)!;
      File? target;
      if (!uri.contains(':')) {
        target = File(
          '${file.parent.path}${Platform.pathSeparator}'
          '${uri.replaceAll('/', Platform.pathSeparator)}',
        );
      } else if (packageName != null &&
          uri.startsWith('package:$packageName/')) {
        final path = uri.substring('package:$packageName/'.length);
        target = File(
          '${lib.path}${Platform.pathSeparator}'
          '${path.replaceAll('/', Platform.pathSeparator)}',
        );
      }
      if (target != null && !target.existsSync()) {
        fail('$name referencia import/export/part inexistente: $uri.');
      }
    }
  }

  final pubignore = File('${root.path}${Platform.pathSeparator}.pubignore');
  if (pubignore.existsSync()) {
    final ignored = pubignore.readAsStringSync();
    for (final entry in [
      '.github/',
      '.dart_tool/',
      'coverage/',
      'build/',
      'doc/api/',
      'documentation/images/',
      'pubspec_overrides.yaml',
      '*.log',
    ]) {
      if (!ignored.contains(entry)) {
        fail('.pubignore não exclui $entry.');
      }
    }
  }

  if (errors.isNotEmpty) {
    stderr.writeln('Falhas de pacote (${errors.length}):');
    for (final error in errors) {
      stderr.writeln('- $error');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'Manifesto, fronteiras Dart puro, imports, documentos, exemplos e testes: OK.',
  );
}
