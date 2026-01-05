import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/route_constants.dart';
import '../../../../core/theme/constants.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/state/auth_state.dart';

class NotesDrawer extends ConsumerWidget {
  const NotesDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authNotifierProvider);

    final email = authState is AuthAuthenticated ? (authState.user.email ?? '') : '';

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: Constants.paddingAllMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Account', style: textTheme.titleMedium),
              Space.verticalSmall,
              Text(
                email.isEmpty ? 'Unknown user' : email,
                style: textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
              Space.verticalMedium,
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Logout?'),
                            content: const Text('You will need to sign in again.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Logout'),
                              ),
                            ],
                          );
                        },
                      ) ??
                      false;

                  if (!confirmed) return;

                  if (!context.mounted) return;

                  Navigator.of(context).pop();

                  await ref.read(authNotifierProvider.notifier).signOut();
                  if (context.mounted) {
                    context.go(RouteConstants.login.toPath);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
