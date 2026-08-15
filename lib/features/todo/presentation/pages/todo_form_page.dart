import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/todo_item.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../widgets/add_todo_form_widget.dart';

/// Full-screen Page for creating and editing Todo tasks
class TodoFormPage extends StatelessWidget {
  final TodoItemEntity? initialTodo;

  const TodoFormPage({
    super.key,
    this.initialTodo,
  });

  bool get isEditing => initialTodo != null;

  void _pop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => _pop(context),
        ),
        title: Text(
          isEditing ? 'Edit Task' : 'New Task',
          style: AppTypography.headline.copyWith(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: AddTodoFormWidget(
            initialTodo: initialTodo,
            onSubmit: (todo) {
              final bloc = context.read<TodoBloc>();
              if (isEditing) {
                bloc.add(UpdateTodoEvent(todo));
              } else {
                bloc.add(AddTodoEvent(todo));
              }
              _pop(context);
            },
          ),
        ),
      ),
    );
  }
}
