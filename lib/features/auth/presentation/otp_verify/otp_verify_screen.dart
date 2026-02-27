import 'dart:async';

import 'package:clean_riverpod/features/auth/presentation/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Sign-up OTP verification screen.
/// Route: /auth/signup-verify?email=foo@bar.com
class OtpVerifyScreen extends ConsumerStatefulWidget {
  final String email;
  const OtpVerifyScreen({super.key, required this.email});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendSeconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter all 6 digits of the code')));
      return;
    }
    final ok = await ref
        .read(otpControllerProvider.notifier)
        .verifyOtp(widget.email, _otp);
    if (ok && mounted) context.go('/');
  }

  Future<void> _resend() async {
    await ref.read(signUpControllerProvider.notifier).sendOtp(widget.email);
    _startTimer();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New OTP sent — check the debug log')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpControllerProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.mark_email_read_outlined, size: 64, color: cs.primary),
            const SizedBox(height: 16),
            Text(
              'Check your inbox',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'We sent a 6-digit code to\n${widget.email}\n(check the debug log for mock OTP)',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // ── 6-digit OTP boxes ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 48,
                  height: 56,
                  child: TextFormField(
                    controller: _controllers[i],
                    focusNode: _focusNodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 5) {
                        _focusNodes[i + 1].requestFocus();
                      }
                      if (v.isEmpty && i > 0) {
                        _focusNodes[i - 1].requestFocus();
                      }
                      // Auto-submit when all 6 filled
                      if (_otp.length == 6) _verify();
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // ── Error ─────────────────────────────────────────────────────
            if (state.hasValue && state.value == null && !state.isLoading) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Invalid OTP. Please try again.',
                    style: TextStyle(color: cs.onErrorContainer),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 16),
            ],

            // ── Verify button ──────────────────────────────────────────────
            FilledButton(
              onPressed: state.isLoading ? null : _verify,
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Verify', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),

            // ── Resend ─────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive it? "),
                _resendSeconds > 0
                    ? Text(
                        'Resend in ${_resendSeconds}s',
                        style: const TextStyle(color: Colors.grey),
                      )
                    : GestureDetector(
                        onTap: _resend,
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                              color: cs.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
