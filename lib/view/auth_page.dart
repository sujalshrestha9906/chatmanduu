import 'dart:io';
import 'package:chatmandu/common_widgets/snack_show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../providers/auth_provider.dart';
import '../providers/common_provider.dart';

class AuthPage extends ConsumerWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(authProvider, (previous, next) {
      if (next.isError) {
        SnackShow.showFailure(context, next.errMessage);
      } else if (next.isSuccess) {
        SnackShow.showSuccess(context, 'success');
      }
    });

    final auth = ref.watch(authProvider);
    final isLogin = ref.watch(loginProvider);
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
                    isLogin ? 'Login Form' : 'SignUp Form',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                  if (!isLogin)
                    TextFormField(
                      controller: nameController,
                      //  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'please provide username';
                        } else if (val.length > 20) {
                          return 'minimum character reached';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          prefixIcon: Icon(Icons.person),
                          hintText: "Username",
                          border: OutlineInputBorder()),
                    ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please provide email';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val)) {
                        return 'please provide valid email';
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Email",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please provide password';
                      } else if (val.length > 20) {
                        return 'minimum character reached';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Password",
                        border: OutlineInputBorder()),
                  ),
                  if (!isLogin)
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
                      onPressed: auth.isLoad
                          ? null
                          : () {
                              _form.currentState!.save();
                              FocusScope.of(context).unfocus();
                              if (_form.currentState!.validate()) {
                                if (isLogin) {
                                  ref.read(authProvider.notifier).userLogin(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim());
                                } else {
                                  if (image == null) {
                                    SnackShow.showFailure(
                                        context, 'please select an image');
                                  } else {
                                    ref.read(authProvider.notifier).userSignUp(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        username: nameController.text.trim(),
                                        image: image);
                                  }
                                }
                              } else {
                                ref.read(mode.notifier).toggle();
                              }
                            },
                      child: auth.isLoad
                          ? Center(child: CircularProgressIndicator())
                          : Text(isLogin ? 'login' : 'SignUp')),
                  SizedBox(
                    height: 6.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin
                            ? 'Don\'t have an account'
                            : "Already a member?",
                      ),
                      TextButton(
                          onPressed: () {
                            _form.currentState!.reset();
                            ref.read(mode.notifier).disable();
                            ref.read(loginProvider.notifier).toggle();
                          },
                          child: Text(
                            isLogin ? 'SignUp' : "Login",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ))
                    ],
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
