import 'dart:async';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class NotesHeaderWidget extends StatefulWidget {
  final int totalNotes;
  final int pinnedNotes;
  final ValueChanged<String> onSearchChanged;

  const NotesHeaderWidget({
    super.key,
    required this.totalNotes,
    required this.pinnedNotes,
    required this.onSearchChanged,
  });

  @override
  State<NotesHeaderWidget> createState() => _NotesHeaderWidgetState();
}

class _NotesHeaderWidgetState extends State<NotesHeaderWidget> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  void _onSearchInputChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 250), () {
      widget.onSearchChanged(query);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes',
                  style: AppTypography.display,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.pinnedNotes > 0
                      ? '${widget.totalNotes} ${widget.totalNotes == 1 ? 'note' : 'notes'} • ${widget.pinnedNotes} pinned'
                      : '${widget.totalNotes} ${widget.totalNotes == 1 ? 'note' : 'notes'}',
                  style: AppTypography.bodySecondary.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Search Bar
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.hairline),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                size: 20,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchInputChanged,
                  style: AppTypography.body.copyWith(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Search notes by title, tag, or content...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSubtle,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _debounceTimer?.cancel();
                    _searchController.clear();
                    widget.onSearchChanged('');
                    setState(() {});
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
