class GeneralApiResponse<T> {
  int? status;
  T? data;
  Object? errors;
  GeneralApiResponse({
    this.status,
    this.data,
    this.errors,
  });

  @override
  String toString() =>
      'GeneralApiResponse(status: $status, data: $data, errors: $errors)';

  @override
  bool operator ==(covariant GeneralApiResponse other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.data == data &&
        other.errors == errors;
  }

  @override
  int get hashCode => status.hashCode ^ data.hashCode ^ errors.hashCode;
}
