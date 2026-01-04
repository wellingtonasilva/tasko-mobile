import 'dart:convert';

sealed class Result<T> {
  const Result();

  factory Result.success(value) => Success(value);
  factory Result.failure(List<String>? errors) => Failure(errors);
}

final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);
}

final class Failure<T> extends Result<T> {
  final List<String>? errors;

  const Failure(this.errors);
}

Result<T> convertToResult<T>(
  T Function(dynamic decodedJson) data,
  dynamic response,
) {
  final decoded = jsonDecode(utf8.decode(response.bodyBytes));

  if (response.statusCode < 300) {
    return Result.success(data(decoded));
  }

  if (decoded['error'] != null) {
    // Erro padrão do Spring/Backend
    return Result.failure([decoded['error']]);
  } else if (decoded['errors'] != null) {
    // Erros relacionados à validação do Spring/Backend
    return Result.failure(
      (decoded['errors'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  return Result.failure(['Erro desconhecido']);
}
