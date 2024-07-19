abstract class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(String errorMessage, String errorCode) apiError,
  });
}

class Success<T> extends ApiResult<T> {
  final T data;

  const Success(this.data);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(String errorMessage, String errorCode) apiError,
  }) {
    return success(data);
  }
}

class Error<T> extends ApiResult<T> {
  final String errorMessage;
  final String errorCode;

  const Error(this.errorMessage, this.errorCode);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(String errorMessage, String errorCode) apiError,
  }) {
    return apiError(errorMessage, errorCode);
  }
}