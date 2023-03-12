import 'package:chatmandu/constants/firebase_instances.dart';
import 'package:chatmandu/view/chatpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../providers/room_provider.dart';

class RecentChats extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final roomData = ref.watch(roomStream);
    return Scaffold(
      body: roomData.when(
          data: (data) {
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final currentUser =
                      FirebaseInstances.firebaseAuth.currentUser!.uid;
                  final otherUser = data[index]
                      .users
                      .firstWhere((element) => element.id != currentUser);
                  final user = data[index]
                      .users
                      .firstWhere((element) => element.id == currentUser);
                  return ListTile(
                    onTap: () {
                      Get.to(() => ChatPage(
                            room: data[index],
                            currentUser: user.firstName!,
                            token: otherUser.metadata!['token'],
                          ));
                    },
                    leading: Image.network(data[index].imageUrl!),
                    title: Text(data[index].name!),
                  );
                });
          },
          error: (err, stack) => Center(child: Text('$err')),
          loading: () => Center(child: CircularProgressIndicator())),
    );
  }
}
