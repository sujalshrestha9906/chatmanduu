import 'package:chatmandu/common_widgets/snack_show.dart';
import 'package:chatmandu/model/post.dart';
import 'package:chatmandu/providers/post_provider.dart';
import 'package:chatmandu/services/post_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class DetailPage extends ConsumerWidget {
  final Post post;
  final types.User user;
  DetailPage(this.post, this.user);

  final commentController = TextEditingController();
  @override
  Widget build(BuildContext context, ref) {
    final posts = ref.watch(postStream);
    return Scaffold(
        body: ListView(
      children: [
        Image.network(
          post.imageUrl,
          height: 300,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.detail),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: commentController,
                onFieldSubmitted: (val) {
                  if (val.isEmpty) {
                    SnackShow.showFailure(context, 'please provide comment');
                  } else {
                    ref.read(postProvider.notifier).addComment([
                      ...post.comments,
                      Comment(
                          imageUrl: user.imageUrl!,
                          comment: val.trim(),
                          userName: user.firstName!)
                    ], post.postId);
                    commentController.clear();
                  }
                },
                decoration: InputDecoration(hintText: 'Add Some Comment'),
              ),
              SizedBox(
                height: 50,
              ),
              posts.when(
                  data: (data) {
                    final postRelated = data
                        .firstWhere((element) => element.postId == post.postId);
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: postRelated.comments.length,
                      itemBuilder: (context, index) {
                        final pos = postRelated.comments[index];
                        return ListTile(
                          leading: Image.network(pos.imageUrl),
                          title: Text(pos.userName),
                          subtitle: Text(pos.comment),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 20,
                        );
                      },
                    );
                  },
                  error: (err, stack) => Center(child: Text('$err')),
                  loading: () => Center(child: CircularProgressIndicator()))
            ],
          ),
        ),
      ],
    ));
  }
}
