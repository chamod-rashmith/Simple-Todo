import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_markdown_view.dart';
import '../../domain/entities/note_entity.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../widgets/markdown_toolbar_widget.dart';

class NoteEditorPage extends StatefulWidget {
  final NoteEntity? initialNote;

  const NoteEditorPage({
    super.key,
    this.initialNote,
  });

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final FocusNode _contentFocusNode;

  String _category = 'General';
  bool _isPinned = false;
  bool _isPreviewMode = false;

  final List<String> _availableCategories = [
    'General',
    'Personal',
    'Work',
    'Ideas',
    'Urgent',
  ];

  @override
  void initState() {
    super.initState();
    final note = widget.initialNote;
    _titleController = TextEditingController(text: note?.title ?? '');
    _contentController = TextEditingController(text: note?.content ?? '');
    _contentFocusNode = FocusNode();
    _category = note?.category ?? 'General';
    _isPinned = note?.isPinned ?? false;

    // Listen to content changes to re-render preview when preview mode is on
    _contentController.addListener(() {
      if (_isPreviewMode) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text;

    if (title.isEmpty && content.trim().isEmpty) {
      context.pop();
      return;
    }

    final effectiveTitle = title.isEmpty
        ? (content.trim().split('\n').firstOrNull ?? 'Untitled Note')
        : title;

    final now = DateTime.now();

    if (widget.initialNote == null) {
      // New Note
      final newNote = NoteEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: effectiveTitle,
        content: content,
        category: _category,
        isPinned: _isPinned,
        createdAt: now,
        updatedAt: now,
      );
      context.read<NotesBloc>().add(AddNoteEvent(newNote));
    } else {
      // Update Note
      final updatedNote = widget.initialNote!.copyWith(
        title: effectiveTitle,
        content: content,
        category: _category,
        isPinned: _isPinned,
        updatedAt: now,
      );
      context.read<NotesBloc>().add(UpdateNoteEvent(updatedNote));
    }

    context.pop();
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Category',
                style: AppTypography.title.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableCategories.map((cat) {
                  final isSelected = cat.toLowerCase() == _category.toLowerCase();
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.black,
                    backgroundColor: AppColors.chipBackground,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? AppColors.black : AppColors.hairline,
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _category = cat;
                        });
                        Navigator.of(ctx).pop();
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nowFormatted = DateFormat('MMM d, yyyy • h:mm a').format(
      widget.initialNote?.updatedAt ?? DateTime.now(),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: _saveNote,
        ),
        title: GestureDetector(
          onTap: _showCategoryPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: _isPinned ? AppColors.black : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _category.toUpperCase(),
                  style: AppTypography.labelUppercase.copyWith(
                    fontSize: 10,
                    color: _isPinned ? AppColors.white : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 14,
                  color: _isPinned ? AppColors.white : AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          // Pin / Important toggle
          IconButton(
            icon: Icon(
              _isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
              color: _isPinned ? AppColors.black : AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _isPinned = !_isPinned;
              });
            },
            tooltip: _isPinned ? 'Unpin note' : 'Pin note',
          ),
          // Toggle Preview Mode
          IconButton(
            icon: Icon(
              _isPreviewMode ? Icons.edit_note_rounded : Icons.visibility_outlined,
              color: _isPreviewMode ? AppColors.black : AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _isPreviewMode = !_isPreviewMode;
              });
            },
            tooltip: _isPreviewMode ? 'Back to Editor' : 'Markdown Preview',
          ),
          // Save Button
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.black, size: 26),
            onPressed: _saveNote,
            tooltip: 'Save Note',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Full Screen Canvas Content
            Expanded(
              child: _isPreviewMode
                  // Rendered Markdown View Canvas
                  ? ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      children: [
                        Text(
                          _titleController.text.trim().isEmpty
                              ? 'Untitled Note'
                              : _titleController.text.trim(),
                          style: AppTypography.display.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          nowFormatted,
                          style: AppTypography.bodySecondary.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: AppColors.hairline),
                        const SizedBox(height: 16),
                        _contentController.text.trim().isEmpty
                            ? Text(
                                'No markdown content to preview.',
                                style: AppTypography.bodySecondary.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.textSubtle,
                                ),
                              )
                            : AppMarkdownView(
                                markdown: _contentController.text,
                                style: AppTypography.body.copyWith(
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                      ],
                    )
                  // Full Screen Typing Canvas
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
                          child: TextField(
                            controller: _titleController,
                            style: AppTypography.headline.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Note Title...',
                              hintStyle: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSubtle,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            maxLines: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              Text(
                                nowFormatted,
                                style: AppTypography.bodySecondary.copyWith(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: AppColors.hairline, height: 1),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: TextField(
                              controller: _contentController,
                              focusNode: _contentFocusNode,
                              style: AppTypography.body.copyWith(
                                fontSize: 16,
                                height: 1.6,
                              ),
                              maxLines: null,
                              expands: true,
                              keyboardType: TextInputType.multiline,
                              textAlignVertical: TextAlignVertical.top,
                              decoration: const InputDecoration(
                                hintText:
                                    'Write note here... (Markdown supported: # Headings, **bold**, - [ ] checklists, `code`)',
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textSubtle,
                                  height: 1.5,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),

            // Markdown Formatting Toolbar (Only in typing mode)
            if (!_isPreviewMode)
              MarkdownToolbarWidget(
                controller: _contentController,
              ),
          ],
        ),
      ),
    );
  }
}
