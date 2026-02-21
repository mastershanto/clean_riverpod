import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SingupScreen extends ConsumerStatefulWidget {
  const SingupScreen({super.key});

  @override
  ConsumerState<SingupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SingupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Signup Screen'),
          ],
        ),
      ),
    );
  }
}