import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/route_constants.dart';
import '../../../../core/theme/constants.dart';

class NotesAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const NotesAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Text('Notes', style: textTheme.titleLarge),
      actions: [
        IconButton(
          onPressed: () => context.go(RouteConstants.noteCreate.toPath),
          icon: Icon(
            Icons.add,
            size: IconSize.large,
            color: Theme.of(context).colorScheme.primary,
          ),
          tooltip: 'Create note',
        ),
      ],
    );
  }
}
