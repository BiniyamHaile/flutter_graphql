import 'package:challenge/cubit/add_todo/add_todo_state.dart';
import 'package:challenge/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AddToDoCubit extends Cubit<AddToDoState> {
  AddToDoCubit({required this.client}) : super(AddToDoInitial());
  final GraphQLClient client;

  void validateForm(String name) {
    if (name.isEmpty) {
      emit(AddToDoError(tr(LocaleKeys.name_cannot_be_empty)));
    } else {
      emit(AddToDoInitial()); // Or any other state that indicates form is valid
    }
  }
}
