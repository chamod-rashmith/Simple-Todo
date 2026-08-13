import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../widgets/todo_category_selector_widget.dart';
import '../widgets/todo_empty_state_widget.dart';
import '../widgets/todo_filter_bar_widget.dart';
import '../widgets/todo_header_widget.dart';
import '../widgets/todo_item_tile_widget.dart';
import '../widgets/todo_stats_banner_widget.dart';
import 'create_todo_modal.dart';

class TodoDashboardPage extends StatelessWidget {
  const TodoDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<TodoBloc, TodoState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            final bloc = context.read<TodoBloc>();

            return RefreshIndicator(
              onRefresh: () async {
                bloc.add(LoadTodosEvent());
              },
              color: AppColors.primary,
              child: CustomScrollView(
                slivers: [
                  // App Header
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    sliver: SliverToBoxAdapter(
                      child: TodoHeaderWidget(
                        onSearchChanged: (query) =>
                            bloc.add(SearchQueryEvent(query)),
                      ),
                    ),
                  ),

                  // Progress Summary Banner
                  if (state.totalCount > 0)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: TodoStatsBannerWidget(
                          completedCount: state.completedCount,
                          totalCount: state.totalCount,
                          ratio: state.completionRatio,
                        ),
                      ),
                    ),

                  // Category Selector
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    sliver: SliverToBoxAdapter(
                      child: TodoCategorySelectorWidget(
                        categories: state.availableCategories,
                        selectedCategory: state.selectedCategory,
                        onSelectCategory: (category) =>
                            bloc.add(SelectCategoryEvent(category)),
                      ),
                    ),
                  ),

                  // Segmented Filter Bar
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: TodoFilterBarWidget(
                        activeFilter: state.activeFilter,
                        onFilterChanged: (filter) =>
                            bloc.add(FilterTodosEvent(filter)),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 16),
                  ),

                  // Main List Body
                  if (state.status == TodoStatus.loading && state.todos.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  else if (state.filteredTodos.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: TodoEmptyStateWidget(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final todo = state.filteredTodos[index];
                            return TodoItemTileWidget(
                              todo: todo,
                              onToggle: () =>
                                  bloc.add(ToggleTodoEvent(todo.id)),
                              onDelete: () =>
                                  bloc.add(DeleteTodoEvent(todo.id)),
                            );
                          },
                          childCount: state.filteredTodos.length,
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await CreateTodoModal.show(context);
          if (newTodo != null && context.mounted) {
            context.read<TodoBloc>().add(AddTodoEvent(newTodo));
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}
