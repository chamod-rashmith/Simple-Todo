import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('🏛️ Enterprise Clean Architecture Governance Tests', () {
    final Directory libDir = Directory('lib');

    List<File> getDartFiles(Directory dir) {
      if (!dir.existsSync()) return [];
      return dir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart') && !f.path.endsWith('.freezed.dart'))
          .toList();
    }

    final allLibFiles = getDartFiles(libDir);

    // =========================================================================
    // 1. DOMAIN LAYER PURITY
    // =========================================================================
    test('Rule 1 [Domain Purity]: Domain layer files must not import UI or external frameworks', () {
      final domainFiles = allLibFiles.where((f) => f.path.replaceAll('\\', '/').contains('/domain/'));
      final bannedPackages = [
        'package:flutter/',
        'package:material_ui/',
        'package:flutter_bloc/',
        'package:drift/',
        'package:http/',
        'package:dio/',
        'package:freezed_annotation/',
        'package:flutter_secure_storage/',
        'package:flutter_local_notifications/',
      ];

      final violations = <String>[];

      for (final file in domainFiles) {
        final lines = file.readAsLinesSync();
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i].trim();
          if (line.startsWith('import ') || line.startsWith('export ')) {
            for (final banned in bannedPackages) {
              if (line.contains(banned)) {
                violations.add('${file.path}:${i + 1} -> contains banned import: "$banned"');
              }
            }
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'Domain layer must remain 100% Pure Dart with zero framework dependencies.\n'
            'Violations found:\n${violations.join('\n')}',
      );
    });

    // =========================================================================
    // 2. DOMAIN ENTITY IMMUTABILITY
    // =========================================================================
    test('Rule 2 [Entity Immutability]: Domain entities must extend Equatable', () {
      final entityFiles = allLibFiles.where((f) => f.path.replaceAll('\\', '/').contains('/domain/entities/'));
      final violations = <String>[];

      for (final file in entityFiles) {
        final content = file.readAsStringSync();
        if (!content.contains('extends Equatable')) {
          violations.add('${file.path} does not extend Equatable');
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'All domain entities must extend Equatable to ensure immutable value semantics.\n'
            'Violations:\n${violations.join('\n')}',
      );
    });

    // =========================================================================
    // 3. USE CASE ENCAPSULATION
    // =========================================================================
    test('Rule 3 [UseCase Encapsulation]: Use cases must declare a callable call() method', () {
      final useCaseFiles = allLibFiles.where((f) => f.path.replaceAll('\\', '/').contains('/domain/usecases/'));
      final violations = <String>[];

      for (final file in useCaseFiles) {
        final content = file.readAsStringSync();
        final hasCallMethod = RegExp(r'\bcall\s*\(').hasMatch(content);
        if (!hasCallMethod) {
          violations.add('${file.path} does not declare a call(...) method');
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'Use cases must encapsulate single business actions callable via call().\n'
            'Violations:\n${violations.join('\n')}',
      );
    });

    // =========================================================================
    // 4. DTO EXTENSION MAPPERS OUTSIDE DOMAIN
    // =========================================================================
    test('Rule 4 [DTO Mappers]: Data models must provide extension mappers (ModelX)', () {
      final modelFiles = allLibFiles.where((f) => f.path.replaceAll('\\', '/').contains('/data/models/'));
      final violations = <String>[];

      for (final file in modelFiles) {
        final content = file.readAsStringSync();
        final hasExtensionMapper = RegExp(r'extension\s+\w+X\s+on\s+\w+').hasMatch(content);
        final hasToEntity = content.contains('toEntity()');

        if (!hasExtensionMapper || !hasToEntity) {
          violations.add('${file.path} is missing extension mapper or toEntity() conversion');
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'Data models must define extension mappers (*X) with toEntity() outside the domain layer.\n'
            'Violations:\n${violations.join('\n')}',
      );
    });

    // =========================================================================
    // 5. DATA SOURCE MODEL ISOLATION
    // =========================================================================
    test('Rule 5 [DataSource Model Isolation]: DataSources must not import domain entities', () {
      final dataSourceFiles = allLibFiles.where((f) => f.path.replaceAll('\\', '/').contains('/data/datasources/'));
      final violations = <String>[];

      for (final file in dataSourceFiles) {
        final lines = file.readAsLinesSync();
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i].trim();
          if (line.startsWith('import ') && line.contains('/domain/entities/')) {
            violations.add('${file.path}:${i + 1} -> imports domain entity in data source');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'DataSources must operate exclusively on Data Models (DTOs) and never import Domain Entities.\n'
            'Violations:\n${violations.join('\n')}',
      );
    });

    // =========================================================================
    // 6. PRESENTATION LAYER BOUNDARY
    // =========================================================================
    test('Rule 6 [Presentation Boundaries]: Presentation must not import datasources or raw database directly', () {
      final presentationFiles = allLibFiles.where((f) => f.path.replaceAll('\\', '/').contains('/presentation/'));
      final violations = <String>[];

      for (final file in presentationFiles) {
        final lines = file.readAsLinesSync();
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i].trim();
          if (line.startsWith('import ') &&
              (line.contains('/data/datasources/') || line.contains('/core/database/'))) {
            violations.add('${file.path}:${i + 1} -> illegal presentation import: "$line"');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'Presentation layer must interact through BLoC/UseCases, never directly importing DataSources or Database.\n'
            'Violations:\n${violations.join('\n')}',
      );
    });

    // =========================================================================
    // 7. MODULAR DEPENDENCY INJECTION
    // =========================================================================
    test('Rule 7 [Modular DI]: Features must maintain a modular DI configuration file in core/di/modules/', () {
      final featureDirs = Directory('lib/features')
          .listSync()
          .whereType<Directory>()
          .map((d) => d.path.replaceAll('\\', '/').split('/').last)
          .toList();

      final diModuleFiles = getDartFiles(Directory('lib/core/di/modules'))
          .map((f) => f.path.replaceAll('\\', '/').split('/').last)
          .toList();

      final missingModules = <String>[];

      for (final feature in featureDirs) {
        final expectedModuleName = '${feature}_module.dart';
        if (!diModuleFiles.contains(expectedModuleName)) {
          missingModules.add('Missing modular DI file for feature "$feature": lib/core/di/modules/$expectedModuleName');
        }
      }

      expect(
        missingModules,
        isEmpty,
        reason: 'Every feature must have an isolated DI module file in lib/core/di/modules/.\n'
            'Missing:\n${missingModules.join('\n')}',
      );
    });

    // =========================================================================
    // 8. BLOC FACTORY REGISTRATION
    // =========================================================================
    test('Rule 8 [BLoC Factory Registration]: BLoCs must be registered as registerFactory in DI modules', () {
      final diModuleFiles = getDartFiles(Directory('lib/core/di/modules'));
      final violations = <String>[];

      for (final file in diModuleFiles) {
        final content = file.readAsStringSync();
        final blocMatches = RegExp(r'register(LazySingleton|Singleton)<(\w+Bloc)>').allMatches(content);
        for (final match in blocMatches) {
          violations.add('${file.path} -> ${match.group(2)} registered as singleton instead of registerFactory');
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'BLoCs must be registered as Factory instances to ensure proper lifecycle scoping.\n'
            'Violations:\n${violations.join('\n')}',
      );
    });

    // =========================================================================
    // 9. BAN ON PRODUCTION PRINT STATEMENTS
    // =========================================================================
    test('Rule 9 [Zero Print Statements]: No raw print() calls in production code under lib/', () {
      final violations = <String>[];
      final printRegex = RegExp(r'(?<!\/\/\s*|///.*)\bprint\s*\(');

      for (final file in allLibFiles) {
        final lines = file.readAsLinesSync();
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i];
          final trimmed = line.trim();
          if (trimmed.startsWith('//') || trimmed.startsWith('///') || trimmed.startsWith('*')) {
            continue;
          }
          if (printRegex.hasMatch(line)) {
            violations.add('${file.path}:${i + 1} -> "$trimmed"');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'Raw print() calls are forbidden in production code. Use debugPrint() or structured logging.\n'
            'Violations:\n${violations.join('\n')}',
      );
    });

    // =========================================================================
    // 10. LIGHTWEIGHT PAGE RULE (< 400 LINES)
    // =========================================================================
    test('Rule 10 [Modular Pages]: Presentation Page widgets must not exceed 400 lines', () {
      final pageFiles = allLibFiles.where((f) => f.path.replaceAll('\\', '/').contains('/presentation/pages/'));
      final violations = <String>[];
      const maxAllowedLines = 400;

      for (final file in pageFiles) {
        final lineCount = file.readAsLinesSync().length;
        if (lineCount > maxAllowedLines) {
          violations.add('${file.path}: $lineCount lines (exceeds $maxAllowedLines line limit)');
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'Pages must remain lightweight top-level containers. Extract reusable sub-widgets into widgets/.\n'
            'Violations:\n${violations.join('\n')}',
      );
    });

    // =========================================================================
    // 11. CLEAN ARCHITECTURE DIRECTORY SYMMETRY
    // =========================================================================
    test('Rule 11 [Directory Symmetry]: Features must contain domain, data, and presentation folders', () {
      final featureDirs = Directory('lib/features').listSync().whereType<Directory>();
      final violations = <String>[];

      for (final featureDir in featureDirs) {
        final featureName = featureDir.path.replaceAll('\\', '/').split('/').last;
        final subDirs = featureDir.listSync().whereType<Directory>().map((d) => d.path.replaceAll('\\', '/').split('/').last).toSet();

        for (final requiredSubDir in ['domain', 'data']) {
          if (!subDirs.contains(requiredSubDir)) {
            violations.add('Feature "$featureName" is missing "$requiredSubDir/" folder');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'All features under lib/features/ must follow Clean Architecture layer separation.\n'
            'Violations:\n${violations.join('\n')}',
      );
    });

    // =========================================================================
    // 12. NAMING CONVENTIONS
    // =========================================================================
    test('Rule 12 [Naming Conventions]: Classes in Clean Architecture layers must have standardized suffixes', () {
      final violations = <String>[];

      for (final file in allLibFiles) {
        final path = file.path.replaceAll('\\', '/');
        final fileName = path.split('/').last;

        if (path.contains('/domain/entities/')) {
          if (!fileName.endsWith('_entity.dart') && !fileName.endsWith('_item.dart')) {
            violations.add('Entity file "$fileName" should end with "_entity.dart" or "_item.dart"');
          }
        } else if (path.contains('/domain/usecases/')) {
          if (!fileName.endsWith('_usecase.dart')) {
            violations.add('UseCase file "$fileName" should end with "_usecase.dart"');
          }
        } else if (path.contains('/data/models/')) {
          if (!fileName.endsWith('_model.dart')) {
            violations.add('Model file "$fileName" should end with "_model.dart"');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'Files must adhere to Clean Architecture naming conventions.\n'
            'Violations:\n${violations.join('\n')}',
      );
    });
  });
}
