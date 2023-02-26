import 'package:chatmandu/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import 'auth_page.dart';

class StatusPage extends ConsumerWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final authData = ref.watch(authStream);
    return Scaffold(
        body: authData.when(
            data: (data) {
              return data == null ? AuthPage() : HomePage();
            },
            error: (err, stack) => Center(child: Text('$err')),
            loading: () => Center(child: CircularProgressIndicator())));
  }
}
