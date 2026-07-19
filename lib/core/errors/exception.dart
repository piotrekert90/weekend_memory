/// Base class for all domain exceptions.
abstract class AppException implements Exception {
  const AppException({
    this.message = 'An unexpected error occurred.',
    this.cause,
  });

  final String message;

  /// The original error that triggered this exception, if any. Kept purely
  /// for diagnostics/logging — callers should still match on the
  /// [AppException] subtype, not on [cause].
  final Object? cause;

  @override
  String toString() => cause == null ? message : '$message (cause: $cause)';
}

/// Exception thrown when a database operation fails.
class DatabaseException extends AppException {
  const DatabaseException({
    super.message = 'A database error occurred.',
    super.cause,
  });
}

/// Exception thrown when a cache operation fails.
class CacheException extends AppException {
  const CacheException({
    super.message = 'A cache error occurred.',
    super.cause,
  });
}

/// Exception thrown when a network operation fails.
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'A network error occurred.',
    super.cause,
  });
}

/// Exception thrown when a file operation fails.
class FileException extends AppException {
  const FileException({super.message = 'A file error occurred.', super.cause});
}

/// Exception representing an unexpected or unclassified error.
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred.',
    super.cause,
  });
}
