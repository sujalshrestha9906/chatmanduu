import 'package:chatmandu/constants/firebase_instances.dart';
import 'package:chatmandu/view/createpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';

class HomePage extends ConsumerWidget {
  final userId = FirebaseInstances.firebaseAuth.currentUser!.uid;
  @override
  Widget build(BuildContext context, ref) {
    final userData = ref.watch(userStream(userId));
    final users = ref.watch(usersStream);
    return Scaffold(
        appBar: AppBar(
          title: Text('Sample Chat'),
        ),
        drawer: Drawer(
          child: userData.when(
              data: (data) {
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
            )
          ],
        ));
  }
}
