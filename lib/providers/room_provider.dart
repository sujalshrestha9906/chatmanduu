import 'package:chatmandu/constants/firebase_instances.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomProvider = Provider((ref) => RoomProvider());
final roomStream =
    StreamProvider.autoDispose((ref) => FirebaseInstances.fireChat.rooms());
final messageStream = StreamProvider.autoDispose.family(
    (ref, types.Room room) => FirebaseInstances.fireChat.messages(room));

class RoomProvider {
  Future<types.Room?> createRoom(types.User user) async {
    try {
      final response = await FirebaseInstances.fireChat.createRoom(user);
      return response;
    } catch (err) {}
  }
}
