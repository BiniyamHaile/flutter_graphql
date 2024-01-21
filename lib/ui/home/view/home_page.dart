import 'package:challenge/app/app.dart';
import 'package:challenge/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graph_repository/bloc/todo/delete_todo_bloc.dart';
import 'package:graph_repository/bloc/todo/todos_bloc.dart';
import 'package:graph_repository/bloc/todo/update_todo_bloc.dart';
import 'package:graph_repository/models/graphql/graphql_api.graphql.dart';
import 'package:graphql_flutter_bloc/graphql_flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text(tr(LocaleKeys.todos))),
      body: BlocBuilder<ToDosBloc, QueryState<GetToDos$Query>>(
        builder: (context, state) {
          if (state is QueryStateLoading<GetToDos$Query>) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QueryStateLoaded<GetToDos$Query>) {
            final todos = state.result.data?['toDos'] as List<dynamic>? ?? [];
            final todoList = todos
                .map((e) => ToDo.fromJson(e as Map<String, dynamic>))
                .toList();
            return todos.isEmpty
                ? Center(
                    child: Text(
                      tr(LocaleKeys.no_todos),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : BlocListener<DeleteToDoBloc,
                    MutationState<DeleteToDo$Mutation>>(
                    listener: (context, state) {
                      if (state
                          is MutationStateCompleted<DeleteToDo$Mutation>) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(tr(LocaleKeys.deleted)),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        context.read<ToDosBloc>().run(); // Refresh the list
                      } else if (state
                          is MutationStateError<DeleteToDo$Mutation>) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('${tr(LocaleKeys.error)}  ${state.error}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: BlocListener<UpdateToDoBloc,
                        MutationState<UpdateToDo$Mutation>>(
                      listener: (context, state) {
                        if (state
                            is MutationStateCompleted<UpdateToDo$Mutation>) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(tr(LocaleKeys.updated)),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                          context.read<ToDosBloc>().run(); // Refresh the list
                        } else if (state
                            is MutationStateError<UpdateToDo$Mutation>) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${tr(LocaleKeys.error)}: ${state.error}',),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todoList[index];
                          final textColor =
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  Theme.of(context).secondaryHeaderColor;
                          return ListTile(
                            title: SizedBox(
                              width: deviceWidth * 0.8,
                              child: Text(
                                todo.name as String? ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                            subtitle: Text(
                              '${tr(LocaleKeys.created_at)}: ${formatTime(todo.createdAt as String? ?? '')}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                checkBoxWidget(
                                  context,
                                  todo.id as String? ?? '',
                                  todo.name as String? ?? '',
                                  todo.createdAt as String? ?? '',
                                  todo.updatedAt ?? '',
                                  done: todo.done ?? false,
                                ),
                                deleteTodoButton(
                                  context,
                                  todo.id,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
          } else if (state is QueryStateError<GetToDos$Query>) {
            return Center(
                child: Text('${tr(LocaleKeys.error)}: ${state.error}'),);
          }
          return Center(
            child: Text(
              tr(LocaleKeys.no_todos),
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(RouterNames.addTodo);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String formatTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return '';
    }
    try {
      final parsedDate = DateTime.parse(dateTimeString);

      return DateFormat('hh:mm a').format(parsedDate);
    } catch (e) {
      return '';
    }
  }
}

Widget deleteTodoButton(BuildContext context, String id) {
  return IconButton(
    icon: const Icon(Icons.delete),
    onPressed: () {
      context.read<DeleteToDoBloc>().run(
            variables: OptionValue<Map<String, dynamic>>({'id': id}),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr(LocaleKeys.deleting)),
          duration: const Duration(seconds: 1),
        ),
      );
    },
  );
}

Widget checkBoxWidget(
  BuildContext context,
  String id,
  String name,
  String createdAt,
  String updatedAt, {
  bool done = false,
}) {
  return Checkbox(
    value: done,
    onChanged: (bool? newValue) {
      final updatedToDo = <String, dynamic>{
        'id': id,
        'name': name,
        'done': newValue,
        'createdAt': createdAt,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      context.read<UpdateToDoBloc>().run(
            variables:
                OptionValue<Map<String, dynamic>>({'input': updatedToDo}),
          );
    },
  );
}
