import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatmandu/constants/firebase_instances.dart';
import 'package:chatmandu/providers/post_provider.dart';
import 'package:chatmandu/services/post_services.dart';
import 'package:chatmandu/view/createpage.dart';
import 'package:chatmandu/view/detailpage.dart';
import 'package:chatmandu/view/recent_chat.dart';
import 'package:chatmandu/view/update_page.dart';
import 'package:chatmandu/view/user_detailpage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../services/notification_services.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final userId = FirebaseInstances.firebaseAuth.currentUser!.uid;

  late types.User user;

  @override
  void initState() {
    super.initState();

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    getToken();
  }

  Future<void> getToken() async {
    final response = await FirebaseMessaging.instance.getToken();
    print(response);
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userStream(userId));
    final users = ref.watch(usersStream);
    final postData = ref.watch(postStream);

    return Scaffold(
        appBar: AppBar(
          title: Text('Sample Chat'),
        ),
        drawer: Drawer(
          child: userData.when(
              data: (data) {
                user = data;
                return ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(data.imageUrl!))),
                      child: Text(data.firstName!),
                    ),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text(data.metadata!['email']),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => CreatePage());
                      },
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Create Post'),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => RecentChats());
                      },
                      leading: Icon(Icons.message),
                      title: Text('Recent Chats'),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        ref.read(authProvider.notifier).userLogOut();
                      },
                      leading: Icon(Icons.exit_to_app),
                      title: Text('SignOut'),
                    )
                  ],
                );
              },
              error: (err, stack) => Center(child: Text('$err')),
              loading: () => Center(child: CircularProgressIndicator())),
        ),
        body: Column(
          children: [
            Container(
              height: 150,
              child: users.when(
                  data: (data) {
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => UserDetailPage(
                                    data[index], user.firstName!));
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 45,
                                    backgroundImage:
                                        NetworkImage(data[index].imageUrl!),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(data[index].firstName!)
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => Container()),
            ),
            Expanded(
                child: postData.when(
                    data: (data) {
                      return ListView.builder(
                          itemCount: data.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: 300,
                                          child: Text(
                                            data[index].title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      if (data[index].userId == userId)
                                        IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                            onPressed: () {
                                              Get.defaultDialog(
                                                  title: 'Customize Post',
                                                  content: Text(
                                                      'Edit or Remove Post'),
                                                  actions: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Get.to(() =>
                                                              UpdatePage(
                                                                  data[index]));
                                                        },
                                                        icon: Icon(Icons.edit)),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon:
                                                            Icon(Icons.delete)),
                                                  ]);
                                            },
                                            icon: Icon(Icons.more_horiz_sharp))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(
                                          () => DetailPage(data[index], user));
                                    },
                                    child: CachedNetworkImage(
                                      height: 400,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      imageUrl: data[index].imageUrl,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: 300,
                                          child: Text(
                                            data[index].detail,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      if (data[index].userId != userId)
                                        Row(
                                          children: [
                                            IconButton(
                                                // padding: EdgeInsets.zero,
                                                // constraints: BoxConstraints(),
                                                onPressed: () {
                                                  if (data[index]
                                                      .like
                                                      .usernames
                                                      .contains(
                                                          user.firstName)) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .hideCurrentSnackBar();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            duration: Duration(
                                                                seconds: 1),
                                                            content: Text(
                                                                'You have already like this post')));
                                                  } else {
                                                    ref
                                                        .read(postProvider
                                                            .notifier)
                                                        .addLike(
                                                            [
                                                          ...data[index]
                                                              .like
                                                              .usernames,
                                                          user.firstName!
                                                        ],
                                                            data[index].postId,
                                                            data[index]
                                                                .like
                                                                .likes);
                                                  }
                                                },
                                                icon: Icon(Icons
                                                    .thumb_up_alt_outlined)),
                                            if (data[index].like.likes != 0)
                                              Text('${data[index].like.likes}')
                                          ],
                                        )
                                    ],
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    error: (err, stack) => Center(child: Text('$err')),
                    loading: () => Center(child: CircularProgressIndicator())))
          ],
        ));
  }
}
