import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_markdown_view.dart';
import '../../domain/entities/note_entity.dart';

class NoteCardWidget extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;
  final VoidCallback onDelete;

  const NoteCardWidget({
    super.key,
    required this.note,
    required this.onTap,
    required this.onTogglePin,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1 && date.day == now.day) {
      return DateFormat('h:mm a').format(date);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE, h:mm a').format(date);
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: note.isPinned ? AppColors.black : AppColors.hairline,
          width: note.isPinned ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Category tag & Pin indicator / action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: note.isPinned
                            ? AppColors.black
                            : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        note.category.toUpperCase(),
                        style: AppTypography.labelUppercase.copyWith(
                          fontSize: 10,
                          color: note.isPinned ? AppColors.white : AppColors.textSecondary,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          icon: Icon(
                            note.isPinned
                                ? Icons.push_pin_rounded
                                : Icons.push_pin_outlined,
                            size: 18,
                            color: note.isPinned
                                ? AppColors.black
                                : AppColors.textSubtle,
                          ),
                          onPressed: onTogglePin,
                          tooltip: note.isPinned ? 'Unpin note' : 'Pin note',
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Note Title
                Text(
                  note.title,
                  style: AppTypography.title.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                if (note.content.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  // Markdown Preview Snippet
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 70),
                    child: ClipRect(
                      child: AppMarkdownView(
                        markdown: note.content.length > 250
                            ? '${note.content.substring(0, 250)}...'
                            : note.content,
                        style: AppTypography.bodySecondary.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                // Bottom row: Date & Word count/Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(note.updatedAt),
                          style: AppTypography.bodySecondary.copyWith(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    if (note.isPinned)
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppColors.black,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Important',
                            style: AppTypography.labelUppercase.copyWith(
                              fontSize: 9,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
