/// Mutators are used to modify some data while accessing it, for example
/// you can have some variable with some user id. You can write mutator for
/// that variable and it can go to some database, search full name of user
/// with that id and return you full name of specified user.
///
/// Mutators can be dataSafe and dataUnsafe when working with reactive collections
/// dataSafe mutations are mutating values on getter and don't modifies initial data
///
/// dataUnsafe mutations are mutating values on setter and you can lose initial data,
/// but dataUnsafe mutations allows us to use sorting methods on mutated lists,
abstract class Mutator<T, E> {
  const Mutator();

  E mutate(T value);
}