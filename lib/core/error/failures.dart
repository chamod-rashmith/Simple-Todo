import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load local data']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid data input']);
}
