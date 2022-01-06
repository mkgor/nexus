/// Guards can be used in variables setters, it gets its' value in [Guard.handle]
/// and can make some computations or something else and do nothing if everything is ok,
/// or throw exception if something went wrong
abstract class Guard<T> {
  void handle(T value);
}