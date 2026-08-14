import 'package:material_ui/material_ui.dart';
import '../../../../../core/theme/app_colors.dart';

class FormSectionLabelWidget extends StatelessWidget {
  final String label;

  const FormSectionLabelWidget({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.textMuted,
        letterSpacing: 0.8,
      ),
    );
  }
}
