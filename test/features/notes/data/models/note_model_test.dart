import 'package:flutter_test/flutter_test.dart';
import 'package:simple_todo/features/notes/data/models/note_model.dart';
import 'package:simple_todo/features/notes/domain/entities/note_entity.dart';

void main() {
  final testDateTime = DateTime(2026, 8, 16, 12, 0);

  final testEntity = NoteEntity(
    id: 'note_1',
    title: 'Architectural Blueprint',
    content: '# Clean Architecture\n- [x] Domain\n- [ ] Data',
    category: 'Work',
    isPinned: true,
    createdAt: testDateTime,
    updatedAt: testDateTime,
  );

  final testModel = NoteModel(
    id: 'note_1',
    title: 'Architectural Blueprint',
    content: '# Clean Architecture\n- [x] Domain\n- [ ] Data',
    category: 'Work',
    isPinned: true,
    createdAt: testDateTime.toIso8601String(),
    updatedAt: testDateTime.toIso8601String(),
  );

  group('NoteModel & NoteModelX Extension Mapper Tests', () {
    test('fromEntity converts NoteEntity to NoteModel correctly', () {
      final result = NoteModelX.fromEntity(testEntity);
      expect(result.id, testEntity.id);
      expect(result.title, testEntity.title);
      expect(result.content, testEntity.content);
      expect(result.category, testEntity.category);
      expect(result.isPinned, testEntity.isPinned);
      expect(result.createdAt, testDateTime.toIso8601String());
      expect(result.updatedAt, testDateTime.toIso8601String());
    });

    test('toEntity converts NoteModel to NoteEntity correctly', () {
      final result = testModel.toEntity();
      expect(result.id, testModel.id);
      expect(result.title, testModel.title);
      expect(result.content, testModel.content);
      expect(result.category, testModel.category);
      expect(result.isPinned, testModel.isPinned);
      expect(result.createdAt, testDateTime);
      expect(result.updatedAt, testDateTime);
    });

    test('toJson and fromJson serialize and deserialize correctly', () {
      final json = testModel.toJson();
      final fromJsonModel = NoteModel.fromJson(json);

      expect(fromJsonModel.id, testModel.id);
      expect(fromJsonModel.title, testModel.title);
      expect(fromJsonModel.content, testModel.content);
      expect(fromJsonModel.category, testModel.category);
      expect(fromJsonModel.isPinned, testModel.isPinned);
    });
  });
}
