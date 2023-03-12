import 'package:chatmandu/services/post_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';

import '../providers/room_provider.dart';
import 'chatpage.dart';

class UserDetailPage extends ConsumerWidget {
  final types.User user;
  final String currentUserName;
  UserDetailPage(this.user, this.currentUserName);

  @override
  Widget build(BuildContext context, ref) {
    final postData = ref.watch(postStream);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.imageUrl!),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.firstName!),
                        Text(user.metadata!['email']),
                        ElevatedButton(
                            onPressed: () async {
                              final response =
                                  await ref.read(roomProvider).createRoom(user);
                              if (response != null) {
                                Get.to(() => ChatPage(
                                      room: response,
                                      token: user.metadata!['token'],
                                      currentUser: currentUserName,
                                    ));
                              }
                            },
                            child: Text('Message'))
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                  child: postData.when(
                      data: (data) {
                        final userPost = data
                            .where((element) => element.userId == user.id)
                            .toList();
                        return GridView.builder(
                            itemCount: userPost.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 2 / 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            itemBuilder: (context, index) {
                              return Image.network(userPost[index].imageUrl);
                            });
                      },
                      error: (err, stack) => Center(child: Text('$err')),
                      loading: () =>
                          Center(child: CircularProgressIndicator())))
            ],
          ),
        ),
      ),
    );
  }
}
