/// Base class for all domain exceptions.
abstract class AppException implements Exception {
  const AppException({this.message = 'An unexpected error occurred.'});

  final String message;
}

/// Exception thrown when a database operation fails.
class DatabaseException extends AppException {
  const DatabaseException({super.message = 'A database error occurred.'});
}

/// Exception thrown when a cache operation fails.
class CacheException extends AppException {
  const CacheException({super.message = 'A cache error occurred.'});
}

/// Exception thrown when a network operation fails.
class NetworkException extends AppException {
  const NetworkException({super.message = 'A network error occurred.'});
}

/// Exception thrown when a file operation fails.
class FileException extends AppException {
  const FileException({super.message = 'A file error occurred.'});
}

/// Exception representing an unexpected or unclassified error.
class UnknownException extends AppException {
  const UnknownException({super.message = 'An unexpected error occurred.'});
}
