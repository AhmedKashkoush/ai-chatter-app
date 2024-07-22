abstract class CommonException implements Exception {
  final String message;
  const CommonException({required this.message});
}

class ServerException extends CommonException {
  const ServerException({required super.message});
}

class NetworkException extends CommonException {
  const NetworkException({required super.message});
}

class CacheException extends CommonException {
  const CacheException({required super.message});
}
