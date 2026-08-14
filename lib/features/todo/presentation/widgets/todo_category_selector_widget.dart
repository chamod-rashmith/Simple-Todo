import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';

class TodoCategorySelectorWidget extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const TodoCategorySelectorWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'all':
        return Icons.grid_view_rounded;
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
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;
          final icon = _getCategoryIcon(cat);

          return GestureDetector(
            onTap: () => onSelectCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.black : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.black : AppColors.hairline,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 15,
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
        },
      ),
    );
  }
}
