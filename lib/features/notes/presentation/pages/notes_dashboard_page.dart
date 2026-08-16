import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../widgets/note_card_widget.dart';
import '../widgets/note_detail_modal.dart';
import '../widgets/notes_category_selector_widget.dart';
import '../widgets/notes_empty_state_widget.dart';
import '../widgets/notes_header_widget.dart';

class NotesDashboardPage extends StatelessWidget {
  const NotesDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<NotesBloc, NotesState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final bloc = context.read<NotesBloc>();

            return RefreshIndicator(
              onRefresh: () async {
                bloc.add(LoadNotesEvent());
              },
              color: AppColors.black,
              backgroundColor: AppColors.white,
              child: CustomScrollView(
                slivers: [
                  // Header with Search Bar and Note Counts
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                    sliver: SliverToBoxAdapter(
                      child: NotesHeaderWidget(
                        totalNotes: state.totalCount,
                        pinnedNotes: state.pinnedCount,
                        onSearchChanged: (query) =>
                            bloc.add(SearchNotesEvent(query)),
                      ),
                    ),
                  ),

                  // Category Filter Carousel
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    sliver: SliverToBoxAdapter(
                      child: NotesCategorySelectorWidget(
                        categories: state.availableCategories,
                        selectedCategory: state.selectedCategory,
                        onSelectCategory: (category) =>
                            bloc.add(SelectNoteCategoryEvent(category)),
                      ),
                    ),
                  ),

                  // Loading State
                  if (state.status == NotesStatus.loading && state.allNotes.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.black,
                        ),
                      ),
                    )
                  // Empty State
                  else if (state.filteredNotes.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: NotesEmptyStateWidget(
                        onAction: () => context.push('/notes/create'),
                      ),
                    )
                  // Notes List with Pinned Section & Other Notes Section
                  else ...[
                    // Pinned Notes Section
                    if (state.pinnedNotes.isNotEmpty) ...[
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.push_pin_rounded,
                                size: 16,
                                color: AppColors.black,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'PINNED & IMPORTANT',
                                style: AppTypography.labelUppercase.copyWith(
                                  fontSize: 11,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final note = state.pinnedNotes[index];
                              return NoteCardWidget(
                                note: note,
                                onTogglePin: () =>
                                    bloc.add(TogglePinNoteEvent(note.id)),
                                onDelete: () =>
                                    bloc.add(DeleteNoteEvent(note.id)),
                                onTap: () => NoteDetailModal.show(
                                  context,
                                  note: note,
                                  onTogglePin: () =>
                                      bloc.add(TogglePinNoteEvent(note.id)),
                                  onDelete: () =>
                                      bloc.add(DeleteNoteEvent(note.id)),
                                ),
                              );
                            },
                            childCount: state.pinnedNotes.length,
                          ),
                        ),
                      ),
                    ],

                    // Other Notes Section
                    if (state.unpinnedNotes.isNotEmpty) ...[
                      if (state.pinnedNotes.isNotEmpty)
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                          sliver: SliverToBoxAdapter(
                            child: Text(
                              'ALL NOTES',
                              style: AppTypography.labelUppercase.copyWith(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final note = state.unpinnedNotes[index];
                              return NoteCardWidget(
                                note: note,
                                onTogglePin: () =>
                                    bloc.add(TogglePinNoteEvent(note.id)),
                                onDelete: () =>
                                    bloc.add(DeleteNoteEvent(note.id)),
                                onTap: () => NoteDetailModal.show(
                                  context,
                                  note: note,
                                  onTogglePin: () =>
                                      bloc.add(TogglePinNoteEvent(note.id)),
                                  onDelete: () =>
                                      bloc.add(DeleteNoteEvent(note.id)),
                                ),
                              );
                            },
                            childCount: state.unpinnedNotes.length,
                          ),
                        ),
                      ),
                    ],

                    // Bottom spacing for navigation bar
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 90),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/notes/create'),
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.edit_note_rounded, size: 28),
      ),
    );
  }
}
