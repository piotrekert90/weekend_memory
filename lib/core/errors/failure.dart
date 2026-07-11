import 'package:equatable/equatable.dart';

/// Base class for all domain failures.
abstract class Failure extends Equatable {
  const Failure({this.message = 'An unexpected error occurred.'});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failure when a database operation fails.
class DatabaseFailure extends Failure {
  const DatabaseFailure({super.message = 'A database error occurred.'});
}

/// Failure when a cache operation fails.
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'A cache error occurred.'});
}

/// Failure when a network operation fails.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'A network error occurred.'});
}

/// Failure when a file operation fails.
class FileFailure extends Failure {
  const FileFailure({super.message = 'A file error occurred.'});
}

/// Failure representing an unexpected or unclassified error.
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unexpected error occurred.'});
}
