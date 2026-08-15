import 'package:material_ui/material_ui.dart';
import '../../../../../core/theme/app_colors.dart';

/// Interactive Markdown helper toolbar providing quick formatting buttons
class MarkdownToolbarWidget extends StatelessWidget {
  final TextEditingController controller;

  const MarkdownToolbarWidget({
    super.key,
    required this.controller,
  });

  void _applyFormat({
    String prefix = '',
    String suffix = '',
    String defaultText = '',
    bool isLinePrefix = false,
  }) {
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) {
      // If no valid selection, append or insert at end
      final newText = '$text$prefix$defaultText$suffix';
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
      return;
    }

    final start = selection.start;
    final end = selection.end;

    if (start == end) {
      // No text highlighted, insert snippet and place cursor between prefix & suffix
      final selectedOrPlaceholder = defaultText;
      final newText = text.replaceRange(start, end, '$prefix$selectedOrPlaceholder$suffix');
      final newCursorPos = start + prefix.length + selectedOrPlaceholder.length;
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newCursorPos),
      );
    } else {
      // Wrap selected text
      final selectedText = text.substring(start, end);
      final replacement = isLinePrefix
          ? '$prefix$selectedText'
          : '$prefix$selectedText$suffix';
      final newText = text.replaceRange(start, end, replacement);
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: start,
          extentOffset: start + replacement.length,
        ),
      );
    }
  }

  Widget _buildButton({
    required Widget icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.hairline, width: 0.8),
              color: AppColors.surfaceContainerLow,
            ),
            child: icon,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildButton(
            tooltip: 'Heading',
            icon: const Text(
              'H',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            onTap: () => _applyFormat(prefix: '### ', isLinePrefix: true),
          ),
          const SizedBox(width: 6),
          _buildButton(
            tooltip: 'Bold',
            icon: const Text(
              'B',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            onTap: () => _applyFormat(prefix: '**', suffix: '**', defaultText: 'bold text'),
          ),
          const SizedBox(width: 6),
          _buildButton(
            tooltip: 'Italic',
            icon: const Text(
              'I',
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            onTap: () => _applyFormat(prefix: '*', suffix: '*', defaultText: 'italic text'),
          ),
          const SizedBox(width: 6),
          _buildButton(
            tooltip: 'Bullet List',
            icon: const Icon(
              Icons.format_list_bulleted_rounded,
              size: 16,
              color: AppColors.textPrimary,
            ),
            onTap: () => _applyFormat(prefix: '- ', isLinePrefix: true, defaultText: 'Item'),
          ),
          const SizedBox(width: 6),
          _buildButton(
            tooltip: 'Task Checkbox',
            icon: const Icon(
              Icons.check_box_outlined,
              size: 16,
              color: AppColors.textPrimary,
            ),
            onTap: () => _applyFormat(prefix: '- [ ] ', isLinePrefix: true, defaultText: 'Task'),
          ),
          const SizedBox(width: 6),
          _buildButton(
            tooltip: 'Code Snippet',
            icon: const Icon(
              Icons.code_rounded,
              size: 16,
              color: AppColors.textPrimary,
            ),
            onTap: () => _applyFormat(prefix: '`', suffix: '`', defaultText: 'code'),
          ),
          const SizedBox(width: 6),
          _buildButton(
            tooltip: 'Quote Block',
            icon: const Icon(
              Icons.format_quote_rounded,
              size: 16,
              color: AppColors.textPrimary,
            ),
            onTap: () => _applyFormat(prefix: '> ', isLinePrefix: true, defaultText: 'Quote'),
          ),
        ],
      ),
    );
  }
}
