import 'package:nexus_codegen/nexus_codegen.dart';
import 'package:nexus/nexus.dart';

part 'reactive_object.g.dart';

class User = UserAbstract with _$UserAbstractMixin;

@NexusObject()
abstract class UserAbstract extends ReactiveObject {
  @Reactive()
  String name;

  @Reactive()
  int weight;

  UserAbstract(this.name, this.weight);
}