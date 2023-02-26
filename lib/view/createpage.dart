import 'dart:io';
import 'package:chatmandu/constants/firebase_instances.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../common_widgets/snack_show.dart';
import '../providers/auth_provider.dart';
import '../providers/common_provider.dart';
import '../providers/post_provider.dart';

class CreatePage extends ConsumerWidget {
  final titleController = TextEditingController();
  final detailController = TextEditingController();

  final _form = GlobalKey<FormState>();

  final uid = FirebaseInstances.fireChat.firebaseUser!.uid;
  @override
  Widget build(BuildContext context, ref) {
    ref.listen(postProvider, (previous, next) {
      if (next.isError) {
        SnackShow.showFailure(context, next.errMessage);
      } else if (next.isSuccess) {
        Get.back();
        SnackShow.showSuccess(context, 'success');
      }
    });

    final post = ref.watch(postProvider);

    final image = ref.watch(imageProvider);
    final mod = ref.watch(mode);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SafeArea(
            child: Form(
              key: _form,
              autovalidateMode: mod,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create Form',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please provide title';
                      }
                      return null;
                    },
                    controller: titleController,
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Title",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    controller: detailController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please provide detai;';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        prefixIcon: Icon(Icons.lock),
                        hintText: "detail",
                        border: OutlineInputBorder()),
                  ),
                  InkWell(
                    onTap: () {
                      Get.defaultDialog(
                          title: 'Select',
                          content: Text('Choose From'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(imageProvider.notifier)
                                      .imagePick(true);
                                },
                                child: Text('Camera')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  ref
                                      .read(imageProvider.notifier)
                                      .imagePick(false);
                                },
                                child: Text('Gallery')),
                          ]);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      child: image == null
                          ? Center(child: Text('please select an image'))
                          : Image.file(File(image.path)),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  ElevatedButton(
                      onPressed: post.isLoad
                          ? null
                          : () {
                              _form.currentState!.save();
                              FocusScope.of(context).unfocus();
                              if (_form.currentState!.validate()) {
                                if (image == null) {
                                  SnackShow.showFailure(
                                      context, 'please select an image');
                                } else {
                                  ref.read(postProvider.notifier).postAdd(
                                      title: titleController.text.trim(),
                                      detail: detailController.text.trim(),
                                      userId: uid,
                                      image: image);
                                }
                              } else {
                                ref.read(mode.notifier).toggle();
                              }
                            },
                      child: post.isLoad
                          ? Center(child: CircularProgressIndicator())
                          : Text('submit')),
                  SizedBox(
                    height: 6.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
