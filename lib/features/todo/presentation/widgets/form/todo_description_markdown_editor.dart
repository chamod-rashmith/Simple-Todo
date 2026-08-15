import 'package:material_ui/material_ui.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_markdown_view.dart';
import 'markdown_toolbar_widget.dart';

/// Rich Markdown Editor widget for Todo descriptions with an expansive writing canvas
class TodoDescriptionMarkdownEditor extends StatefulWidget {
  final TextEditingController controller;
  final int minLines;
  final int? maxLines;
  final double minHeight;

  const TodoDescriptionMarkdownEditor({
    super.key,
    required this.controller,
    this.minLines = 12,
    this.maxLines = 30,
    this.minHeight = 320,
  });

  @override
  State<TodoDescriptionMarkdownEditor> createState() =>
      _TodoDescriptionMarkdownEditorState();
}

class _TodoDescriptionMarkdownEditorState
    extends State<TodoDescriptionMarkdownEditor> {
  bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted && _isPreviewMode) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.hairline, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar: Segmented Switcher & Markdown Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              border: Border(
                bottom: BorderSide(color: AppColors.hairline, width: 0.8),
              ),
            ),
            child: Row(
              children: [
                // Write / Preview Pill Toggle
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.hairline,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton(
                        label: 'Write',
                        icon: Icons.edit_note_rounded,
                        isSelected: !_isPreviewMode,
                        onTap: () {
                          if (_isPreviewMode) {
                            setState(() => _isPreviewMode = false);
                          }
                        },
                      ),
                      _buildTabButton(
                        label: 'Preview',
                        icon: Icons.visibility_outlined,
                        isSelected: _isPreviewMode,
                        onTap: () {
                          if (!_isPreviewMode) {
                            setState(() => _isPreviewMode = true);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Markdown Toolbar (visible in Write mode)
                if (!_isPreviewMode)
                  Expanded(
                    child: MarkdownToolbarWidget(
                      controller: widget.controller,
                    ),
                  )
                else
                  const Spacer(),
              ],
            ),
          ),

          // Expansive Canvas Area: Editor vs Markdown Preview
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _isPreviewMode
                ? Container(
                    key: const ValueKey('preview'),
                    constraints: BoxConstraints(minHeight: widget.minHeight),
                    padding: const EdgeInsets.all(18),
                    alignment: Alignment.topLeft,
                    child: text.trim().isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 64),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_stories_outlined,
                                    size: 32,
                                    color: AppColors.textSubtle,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'No markdown content yet.\nSwitch to "Write" tab to add notes.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSubtle,
                                      fontStyle: FontStyle.italic,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : AppMarkdownView(
                            markdown: text,
                            style: AppTypography.body.copyWith(
                              fontSize: 14.5,
                              height: 1.55,
                            ),
                          ),
                  )
                : Container(
                    key: const ValueKey('write'),
                    constraints: BoxConstraints(minHeight: widget.minHeight),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: TextFormField(
                      controller: widget.controller,
                      minLines: widget.minLines,
                      maxLines: widget.maxLines,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(
                        fontSize: 14.5,
                        color: AppColors.textPrimary,
                        height: 1.55,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Write detailed notes with markdown...\n\n# Main Heading\n## Subheading\n- [ ] Task checkbox\n- Bullet list item\n`code snippet`\n**bold text**\n> Quote or reference',
                        hintStyle: TextStyle(
                          color: AppColors.textSubtle,
                          fontSize: 13.5,
                          height: 1.55,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
          ),

          // Footer info (Character count & Markdown indicator)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.hairline, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.description_outlined,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Markdown supported',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${text.length} chars • ${text.isEmpty ? 0 : text.split('\n').length} lines',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSubtle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? AppColors.black : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.black : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
