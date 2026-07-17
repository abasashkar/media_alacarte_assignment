import 'package:equatable/equatable.dart';

/// Base type for all recoverable, user-facing errors surfaced to the UI.
///
/// Repositories convert low-level exceptions into a [Failure] so blocs and
/// widgets never deal with Dio/parsing internals directly.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// No connectivity, timeouts, or the request never reached the server.
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message =
        'No internet connection. Please check your network and try again.',
  ]);
}

/// Server responded with a non-2xx status code.
class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Something went wrong on the server. Please try again.',
  ]);
}

/// Response body could not be parsed into the expected model.
class ParsingFailure extends Failure {
  const ParsingFailure([
    super.message = 'We received an unexpected response. Please try again.',
  ]);
}

/// Anything not covered by the cases above.
class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'An unexpected error occurred. Please try again.',
  ]);
}
