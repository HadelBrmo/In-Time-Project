// DECORATOR PATTERN for retry
class RetryDataSource<T> implements DataSourceDecorator<T> {
  // NFR: Reliability
  @override
  Future<T> fetchData() async {
    // Implement retry logic
    throw UnimplementedError();
  }
}