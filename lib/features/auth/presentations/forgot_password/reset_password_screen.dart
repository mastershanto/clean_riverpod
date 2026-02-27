import 'dart:async';

import 'package:clean_riverpod/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Step 2+3 of forgot-password: verify OTP then set a new password.
/// Route: /auth/forgot-otp?email=foo@bar.com
class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  // OTP boxes
  final List<TextEditingController> _otpCtrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  // New-password form
  final _formKey = GlobalKey<FormState>();
  final _newPassCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscure = true;
  bool _obscureConfirm = true;
  bool _otpVerified = false;
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
    for (final c in _otpCtrls) { c.dispose(); }
    for (final f in _otpFocusNodes) { f.dispose(); }
    _newPassCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String get _otpValue => _otpCtrls.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    if (_otpValue.length < 6) return;
    final ok = await ref
        .read(forgotPasswordControllerProvider.notifier)
        .verifyOtp(widget.email, _otpValue);
    if (ok && mounted) setState(() => _otpVerified = true);
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref
        .read(forgotPasswordControllerProvider.notifier)
        .resetPassword(
          email: widget.email,
          otp: _otpValue,
          newPassword: _newPassCtrl.text.trim(),
        );
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully!')));
      context.go('/auth');
    }
  }

  Future<void> _resend() async {
    await ref
        .read(forgotPasswordControllerProvider.notifier)
        .resendOtp(widget.email);
    _startTimer();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New OTP sent — check the debug log')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordControllerProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Icon(
              _otpVerified
                  ? Icons.check_circle_outline_rounded
                  : Icons.sms_outlined,
              size: 64,
              color: _otpVerified ? Colors.green : cs.primary,
            ),
            const SizedBox(height: 16),
            Text(
              _otpVerified ? 'Create New Password' : 'Enter Reset Code',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _otpVerified
                  ? 'Almost done — set your new password below.'
                  : 'Enter the 6-digit code sent to\n${widget.email}\n(check the debug log for mock OTP)',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            // ─────────────────────────────────────────────────────────────
            // STEP A: OTP boxes (before verification)
            // ─────────────────────────────────────────────────────────────
            if (!_otpVerified) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 48,
                    height: 56,
                    child: TextFormField(
                      controller: _otpCtrls[i],
                      focusNode: _otpFocusNodes[i],
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
                          _otpFocusNodes[i + 1].requestFocus();
                        }
                        if (v.isEmpty && i > 0) {
                          _otpFocusNodes[i - 1].requestFocus();
                        }
                        if (_otpValue.length == 6) _verifyOtp();
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              if (state.hasValue &&
                  state.value == false &&
                  !state.isLoading) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Invalid code. Please try again.',
                      style: TextStyle(color: cs.onErrorContainer),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: 12),
              ],

              FilledButton(
                onPressed: state.isLoading ? null : _verifyOtp,
                style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Verify Code',
                        style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Didn't receive it? "),
                  _resendSeconds > 0
                      ? Text('Resend in ${_resendSeconds}s',
                          style: const TextStyle(color: Colors.grey))
                      : GestureDetector(
                          onTap: _resend,
                          child: Text('Resend',
                              style: TextStyle(
                                  color: cs.primary,
                                  fontWeight: FontWeight.bold)),
                        ),
                ],
              ),
            ],

            // ─────────────────────────────────────────────────────────────
            // STEP B: New password form (after OTP verified)
            // ─────────────────────────────────────────────────────────────
            if (_otpVerified)
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _newPassCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) => v == null || v.length < 6
                          ? 'Min 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                      ),
                      validator: (v) => v != _newPassCtrl.text
                          ? 'Passwords do not match'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    if (state.hasError) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(state.error.toString(),
                            style: TextStyle(color: cs.onErrorContainer),
                            textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 12),
                    ],

                    FilledButton(
                      onPressed: state.isLoading ? null : _resetPassword,
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Reset Password',
                              style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
