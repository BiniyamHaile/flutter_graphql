import 'package:equatable/equatable.dart';
import 'package:graph_repository/models/graphql/graphql_api.dart';

abstract class AddToDoState extends Equatable {
  const AddToDoState();

  @override
  List<Object> get props => [];
}

class AddToDoInitial extends AddToDoState {}

class AddToDoLoading extends AddToDoState {}

class AddToDoSuccess extends AddToDoState {
  const AddToDoSuccess(this.todo);
  final ToDo todo;

  @override
  List<Object> get props => [todo];
}

class AddToDoError extends AddToDoState {
  const AddToDoError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
