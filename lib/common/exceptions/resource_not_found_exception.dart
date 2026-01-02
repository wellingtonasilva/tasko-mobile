class ResourceNotFoundException implements Exception {
  final String? msg;

  const ResourceNotFoundException([this.msg]);

  @override
  String toString() => msg ?? 'ResourceNotFoundException';
}
