import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/route_constants.dart';
import '../../../../core/theme/constants.dart';
import '../../../../core/network/connectivity_providers.dart';
import '../notifiers/notes_notifier.dart';
import '../state/notes_state.dart';
import '../widgets/note_card.dart';
import '../widgets/notes_app_bar.dart';
import '../widgets/notes_drawer.dart';

class NotesListPage extends HookConsumerWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final searchController = useTextEditingController();
    final query = useState<String>('');

    ref.listen(isOnlineProvider, (previous, next) {
      final wasOnline = previous?.valueOrNull;
      final isOnline = next.valueOrNull;

      if (wasOnline == isOnline) return;

      if (isOnline == false) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('You are offline'),
              duration: Duration(days: 1),
            ),
          );
      }

      if (isOnline == true) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    });

    final state = ref.watch(notesNotifierProvider);

    final allNotes = switch (state) {
      NotesLoaded s => s.notes,
      _ => const [],
    };

    final normalizedQuery = query.value.trim().toLowerCase();
    final notes = normalizedQuery.isEmpty
        ? allNotes
        : allNotes
            .where(
              (n) => n.title.toLowerCase().contains(normalizedQuery) ||
                  n.content.toLowerCase().contains(normalizedQuery),
            )
            .toList(growable: false);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const NotesAppBar(),
      drawer: const NotesDrawer(),
      body: SafeArea(
        child: Padding(
          padding: Constants.paddingAllMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: searchController,
                onChanged: (v) {
                  query.value = v;
                  if (v.trim().isEmpty) {
                    FocusScope.of(context).unfocus();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search notes',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: query.value.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            query.value = '';
                            FocusScope.of(context).unfocus();
                          },
                          icon: const Icon(Icons.clear),
                          tooltip: 'Clear',
                        ),
                  border: OutlineInputBorder(
                    borderRadius: Constants.borderRadiusMedium,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: Constants.borderRadiusMedium,
                  ),
                ),
              ),
              Space.verticalMedium,
              Expanded(
                child: switch (state) {
                  NotesLoading() => const Center(child: CircularProgressIndicator()),
                  NotesError(:final message) => Center(
                      child: Text(
                        message,
                        style: textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  NotesLoaded() when allNotes.isEmpty => Center(
                      child: Text(
                        'No notes yet. Tap + to create one.',
                        style: textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  NotesLoaded() when notes.isEmpty => Center(
                      child: Text(
                        'No results found.',
                        style: textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  NotesLoaded() => RefreshIndicator(
                      onRefresh: () => ref.read(notesNotifierProvider.notifier).refresh(),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: notes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: Constants.paddingSmall),
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return NoteCard(
                            note: note,
                            onTap: () => context.push(
                              RouteConstants.noteEdit.toPath.replaceFirst(':noteId', note.id),
                            ),
                            onDelete: () async {
                              final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete note?'),
                                        content: const Text('This action cannot be undone.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  ) ??
                                  false;

                              if (!confirmed) return;

                              await ref.read(notesNotifierProvider.notifier).deleteNote(note.id);

                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(content: Text('Note deleted')));
                              }
                            },
                          );
                        },
                      ),
                    ),
                  _ => const SizedBox.shrink(),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
