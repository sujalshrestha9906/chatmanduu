import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatmandu/constants/firebase_instances.dart';
import 'package:chatmandu/providers/post_provider.dart';
import 'package:chatmandu/services/post_services.dart';
import 'package:chatmandu/view/createpage.dart';
import 'package:chatmandu/view/detailpage.dart';
import 'package:chatmandu/view/update_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class HomePage extends ConsumerWidget {
  final userId = FirebaseInstances.firebaseAuth.currentUser!.uid;
  late types.User user;
  @override
  Widget build(BuildContext context, ref) {
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
