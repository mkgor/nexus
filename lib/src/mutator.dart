abstract class Mutator<T, E> {
  const Mutator();

  E mutate(T value);
}