import 'package:clean_riverpod/features/auth/repositories/auth_repository%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // স্টেটটি ওয়াচ (Watch) করা
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Clean Architecture Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: "Email")),
            const TextField(decoration: InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            
            // স্টেটের ওপর ভিত্তি করে বাটন দেখানো
            authState.maybeWhen(
              loading: () => const CircularProgressIndicator(),
              orElse: () => ElevatedButton(
                onPressed: () {
                  // কন্ট্রোলার কল করা
                  ref.read(authControllerProvider.notifier).signIn(
                    "test@test.com", 
                    "123456"
                  );
                },
                child: const Text("Login"),
              ),
            ),

            // এরর বা সাকসেস মেসেজ দেখানো
            if (authState.hasValue && authState.value == true)
              const Text("Login Successful!", style: TextStyle(color: Colors.green)),
            if (authState.hasValue && authState.value == false)
              const Text("Invalid Credentials", style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}