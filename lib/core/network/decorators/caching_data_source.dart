// DECORATOR PATTERN for caching
abstract class DataSourceDecorator<T> {
  Future<T> fetchData();
}

class CachingDataSource<T> implements DataSourceDecorator<T> {
  // NFR: Availability & Performance
  @override
  Future<T> fetchData() async {
    // Implement caching logic
    throw UnimplementedError();
  }
}