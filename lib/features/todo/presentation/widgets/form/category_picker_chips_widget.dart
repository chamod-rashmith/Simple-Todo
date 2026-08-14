import 'package:material_ui/material_ui.dart';
import '../../../../../core/theme/app_colors.dart';

class CategoryPickerChipsWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const CategoryPickerChipsWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return Icons.business_center_outlined;
      case 'personal':
        return Icons.person_outline_rounded;
      case 'design':
        return Icons.brush_outlined;
      case 'health':
        return Icons.favorite_border_rounded;
      default:
        return Icons.label_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((cat) {
        final isSelected = cat == selectedCategory;
        final icon = _getCategoryIcon(cat);

        return GestureDetector(
          onTap: () => onSelected(cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.black : AppColors.chipBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.black : AppColors.hairline,
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  cat,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
