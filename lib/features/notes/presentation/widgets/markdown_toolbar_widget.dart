import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class MarkdownToolbarWidget extends StatelessWidget {
  final TextEditingController controller;

  const MarkdownToolbarWidget({
    super.key,
    required this.controller,
  });

  void _insertMarkdown(String prefix, [String suffix = '']) {
    final text = controller.text;
    final selection = controller.selection;

    if (selection.start < 0 || selection.end < 0) {
      // If no cursor position, append to end
      controller.text = '$text$prefix$suffix';
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length - suffix.length,
      );
      return;
    }

    final selectedText = text.substring(selection.start, selection.end);
    final replacement = '$prefix$selectedText$suffix';
    final newText = text.replaceRange(selection.start, selection.end, replacement);

    controller.text = newText;
    final cursorPosition = selection.start + prefix.length + selectedText.length;
    controller.selection = TextSelection.collapsed(offset: cursorPosition);
  }

  void _insertBlockPrefix(String prefix) {
    final text = controller.text;
    final selection = controller.selection;

    if (selection.start < 0) {
      controller.text = '$text\n$prefix';
      return;
    }

    // Find the start of current line
    final beforeCursor = text.substring(0, selection.start);
    final lastNewline = beforeCursor.lastIndexOf('\n');
    final lineStart = lastNewline == -1 ? 0 : lastNewline + 1;

    final newText = text.replaceRange(lineStart, lineStart, prefix);
    controller.text = newText;
    controller.selection = TextSelection.collapsed(
      offset: selection.start + prefix.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.hairline, width: 1),
          bottom: BorderSide(color: AppColors.hairline, width: 1),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          _ToolbarButton(
            label: 'B',
            isBold: true,
            tooltip: 'Bold',
            onTap: () => _insertMarkdown('**', '**'),
          ),
          _ToolbarButton(
            label: 'I',
            isItalic: true,
            tooltip: 'Italic',
            onTap: () => _insertMarkdown('*', '*'),
          ),
          _ToolbarButton(
            label: 'H1',
            tooltip: 'Heading 1',
            onTap: () => _insertBlockPrefix('# '),
          ),
          _ToolbarButton(
            label: 'H2',
            tooltip: 'Heading 2',
            onTap: () => _insertBlockPrefix('## '),
          ),
          _ToolbarButton(
            icon: Icons.checklist_rounded,
            tooltip: 'Checklist Item',
            onTap: () => _insertBlockPrefix('- [ ] '),
          ),
          _ToolbarButton(
            icon: Icons.format_list_bulleted_rounded,
            tooltip: 'Bullet List',
            onTap: () => _insertBlockPrefix('- '),
          ),
          _ToolbarButton(
            icon: Icons.format_quote_rounded,
            tooltip: 'Quote',
            onTap: () => _insertBlockPrefix('> '),
          ),
          _ToolbarButton(
            icon: Icons.code_rounded,
            tooltip: 'Code',
            onTap: () => _insertMarkdown('`', '`'),
          ),
          _ToolbarButton(
            icon: Icons.horizontal_rule_rounded,
            tooltip: 'Divider',
            onTap: () => _insertMarkdown('\n---\n'),
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isBold;
  final bool isItalic;

  const _ToolbarButton({
    this.label,
    this.icon,
    required this.tooltip,
    required this.onTap,
    this.isBold = false,
    this.isItalic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              alignment: Alignment.center,
              child: icon != null
                  ? Icon(icon, size: 18, color: AppColors.textPrimary)
                  : Text(
                      label ?? '',
                      style: AppTypography.button.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
                        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
