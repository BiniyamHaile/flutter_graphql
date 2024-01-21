import 'package:challenge/generated/locale_keys.g.dart';
import 'package:challenge/ui/add_todo/view/add_todo_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:graph_repository/graph_repository.dart';
import 'package:graphql_flutter_bloc/graphql_flutter_bloc.dart';

class AddToDoPage extends StatelessWidget {
  const AddToDoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text(tr(LocaleKeys.add_todo))),
      body: BlocConsumer<AddToDoBloc, MutationState<AddToDo$Mutation>>(
        listener: (context, state) {
          if (state is MutationStateCompleted<AddToDo$Mutation>) {
            context.read<ToDosBloc>().run();
            context.pop();
          } else if (state is MutationStateError<AddToDo$Mutation>) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tr(LocaleKeys.error_adding_todo))),
            );
          }
        },
        builder: (context, state) {
          if (state is MutationStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: 0.01 * deviceHeight,
              horizontal: 0.05 * deviceWidth,
            ),
            child: AddToDoForm(
              onFormSubmit: ({required String name, bool? done}) {
                final addToDoInput = ToDoInput(
                  id: '',
                  name: name,
                  done: done,
                  createdAt: DateTime.now().toIso8601String(),
                );

                final variables =
                    AddToDoArguments(input: addToDoInput).toJson();

                BlocProvider.of<AddToDoBloc>(context).run(
                  variables: OptionValue<Map<String, dynamic>>(variables),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
