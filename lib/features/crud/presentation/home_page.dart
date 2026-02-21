import 'package:clean_riverpod/features/crud/presentation/widgets/delete_confirmation_dialog.dart';
import 'package:clean_riverpod/features/crud/presentation/widgets/empty_state.dart';
import 'package:clean_riverpod/features/crud/presentation/widgets/user_card.dart';
import 'package:clean_riverpod/features/crud/presentation/widgets/user_form_dialog.dart';
import 'package:clean_riverpod/features/crud/models/user_model.dart';
import 'package:clean_riverpod/features/crud/providers/theme_provider.dart';
import 'package:clean_riverpod/features/crud/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userProvider);
    final isDark = ref.watch(themeProvider.notifier).isDark;

    return Scaffold(
      appBar: _buildAppBar(context, ref, isDark),
      floatingActionButton: _buildFAB(context, ref),
      body: usersAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        data: (users) => users.isEmpty
            ? const EmptyState()
            : _buildUserList(context, ref, users),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, WidgetRef ref, bool isDark) {
    return AppBar(
      title: Text(title),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        IconButton(
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
        ),
      ],
    );
  }

  FloatingActionButton _buildFAB(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddUserDialog(context, ref),
      icon: const Icon(Icons.person_add),
      label: const Text('Add User'),
    );
  }

  Widget _buildUserList(
    BuildContext context,
    WidgetRef ref,
    List<UserModel> users,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          user: user,
          onEdit: () => _showEditUserDialog(context, ref, user),
          onDelete: () => _showDeleteDialog(context, ref, user),
        );
      },
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => UserFormDialog(
        initialName: '',
        initialEmail: '',
        initialPhone: '',
        initialAddress: '',
        isEdit: false,
        onSave: (name, email, phone, address) async {
          await ref.read(userProvider.notifier).addUser(
                UserModel(
                  id: '',
                  name: name,
                  email: email,
                  phone: phone,
                  address: address,
                ),
              );
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  void _showEditUserDialog(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => UserFormDialog(
        initialName: user.name,
        initialEmail: user.email,
        initialPhone: user.phone,
        initialAddress: user.address,
        isEdit: true,
        onSave: (name, email, phone, address) async {
          await ref.read(userProvider.notifier).updateUser(
                user.copyWith(
                  name: name,
                  email: email,
                  phone: phone,
                  address: address,
                ),
              );
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, UserModel user) {
    showDialog<void>(
      context: context,
      builder: (ctx) => DeleteConfirmationDialog(
        userName: user.name,
        onConfirm: () async {
          await ref.read(userProvider.notifier).deleteUser(user.id);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
