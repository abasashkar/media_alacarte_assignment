import '../network/api_exception.dart';
import 'failure.dart';

/// Maps low-level exceptions thrown by data sources into typed [Failure]s.
Failure mapErrorToFailure(Object error) {
  if (error is ApiException) {
    return switch (error.type) {
      ApiExceptionType.timeout ||
      ApiExceptionType.network =>
        NetworkFailure(error.message),
      ApiExceptionType.server => ServerFailure(error.message),
      _ => UnknownFailure(error.message),
    };
  }
  if (error is FormatException || error is TypeError) {
    return const ParsingFailure();
  }
  return const UnknownFailure();
}
