import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_markdown_view.dart';
import '../../domain/entities/note_entity.dart';

class NoteDetailModal extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback onTogglePin;
  final VoidCallback onDelete;

  const NoteDetailModal({
    super.key,
    required this.note,
    required this.onTogglePin,
    required this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required NoteEntity note,
    required VoidCallback onTogglePin,
    required VoidCallback onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NoteDetailModal(
        note: note,
        onTogglePin: onTogglePin,
        onDelete: onDelete,
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: '# ${note.title}\n\n${note.content}'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note copied to clipboard'),
        backgroundColor: AppColors.black,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Top Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Action Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: note.isPinned ? AppColors.black : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        note.category.toUpperCase(),
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                          color: note.isPinned ? AppColors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            note.isPinned
                                ? Icons.push_pin_rounded
                                : Icons.push_pin_outlined,
                            color: note.isPinned ? AppColors.black : AppColors.textSecondary,
                          ),
                          onPressed: () {
                            onTogglePin();
                            Navigator.of(context).pop();
                          },
                          tooltip: note.isPinned ? 'Unpin note' : 'Pin note',
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, color: AppColors.textSecondary),
                          onPressed: () => _copyToClipboard(context),
                          tooltip: 'Copy markdown',
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.push('/notes/edit', extra: note);
                          },
                          tooltip: 'Edit note',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                          onPressed: () {
                            onDelete();
                            Navigator.of(context).pop();
                          },
                          tooltip: 'Delete note',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(color: AppColors.hairline, height: 1),

              // Content Body
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Note Title
                    Text(
                      note.title,
                      style: AppTypography.headline.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Timestamp
                    Text(
                      'Last edited ${dateFormat.format(note.updatedAt)}',
                      style: AppTypography.bodySecondary.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(color: AppColors.hairline, height: 1),
                    const SizedBox(height: 20),

                    // Rendered Markdown Content
                    if (note.content.trim().isEmpty)
                      Text(
                        'No content provided.',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSubtle,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      AppMarkdownView(
                        markdown: note.content,
                        style: AppTypography.body.copyWith(
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
