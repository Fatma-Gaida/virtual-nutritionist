import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

abstract class UserEvent {}

class CreateUserEvent extends UserEvent {
  final User user;
  CreateUserEvent(this.user);
}

class FetchUserEvent extends UserEvent {
  final String id;
  FetchUserEvent(this.id);
}

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final User user;
  UserSuccess(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<CreateUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userRepository.createUser(event.user);
        emit(UserSuccess(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<FetchUserEvent>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userRepository.getUserById(event.id);
        emit(UserSuccess(user));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}