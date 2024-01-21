import 'package:challenge/cubit/add_todo/add_todo_cubit.dart';
import 'package:challenge/cubit/add_todo/add_todo_state.dart';
import 'package:challenge/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddToDoForm extends StatefulWidget {
  const AddToDoForm({super.key, required this.onFormSubmit});
  final void Function({required String name, bool? done}) onFormSubmit;
  @override
  _AddToDoFormState createState() => _AddToDoFormState();
}

class _AddToDoFormState extends State<AddToDoForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  bool _done = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      _formKey.currentState?.save();
      _formKey.currentState?.save();
      context.read<AddToDoCubit>().validateForm(_name);

      if (context.read<AddToDoCubit>().state is! AddToDoError) {
        widget.onFormSubmit(name: _name, done: _done);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddToDoCubit, AddToDoState>(
      listener: (context, state) {
        if (state is AddToDoError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          );
        }
      },
      child: BlocBuilder<AddToDoCubit, AddToDoState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              var width = constraints.maxWidth;

              if (width > 600) {
                width = width * 0.8;
              }

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: width,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: tr(LocaleKeys.name)),
                          onSaved: (value) => _name = value ?? '',
                        ),
                        CheckboxListTile(
                          title: Text(tr(LocaleKeys.done)),
                          value: _done,
                          onChanged: (newValue) =>
                              setState(() => _done = newValue ?? false),
                        ),
                        ElevatedButton(
                          onPressed: _submit,
                          child: Text(tr(LocaleKeys.add_todo)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
