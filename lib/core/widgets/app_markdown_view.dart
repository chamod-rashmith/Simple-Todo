import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:material_ui/material_ui.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Reusable Markdown viewer widget backed by gpt_markdown
/// Adheres to app color palette, typography tokens, and minimalist aesthetic.
class AppMarkdownView extends StatelessWidget {
  final String markdown;
  final TextStyle? style;
  final TextDirection textDirection;

  const AppMarkdownView({
    super.key,
    required this.markdown,
    this.style,
    this.textDirection = TextDirection.ltr,
  });

  String _preprocessMarkdown(String raw) {
    // Normalize markdown checklist syntax (- [x] and - [ ]) into robust unicode symbols
    // to avoid gpt_markdown 1.1.8 internal unconstrained RenderFlex measurement assertion.
    return raw
        .replaceAll(RegExp(r'^\s*-\s*\[x\]\s*', multiLine: true), '☑ ')
        .replaceAll(RegExp(r'^\s*-\s*\[\s*\]\s*', multiLine: true), '☐ ');
  }

  @override
  Widget build(BuildContext context) {
    if (markdown.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final defaultStyle = style ?? AppTypography.bodySecondary;
    final processedMarkdown = _preprocessMarkdown(markdown);

    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: AppColors.surfaceContainerLow,
      ),
      child: GptMarkdown(
        processedMarkdown,
        style: defaultStyle,
        textDirection: textDirection,
      ),
    );
  }
}
