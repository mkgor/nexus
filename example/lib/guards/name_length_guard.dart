import 'package:nexus/nexus.dart';

class NameLengthGuard implements Guard<dynamic> {
  const NameLengthGuard();

  @override
  void handle(dynamic value) {
    if(value is String && value.length < 4)
      throw Exception("Name can't be less than 4 characters");

    if(value is List) {
      print(value.length);
    }
  }
}