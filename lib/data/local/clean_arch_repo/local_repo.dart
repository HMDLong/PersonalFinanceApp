abstract class LocalRepository<T> {
  void put(T value);
  void putAll(List<T> values);
  T? getAt(dynamic id);
  List<T> getAll();
  void updateAt(dynamic id, T newT);
  void deleteAt(dynamic id);
  void deleteAll();
}