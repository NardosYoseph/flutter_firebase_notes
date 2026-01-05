import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/route_constants.dart';
import '../../../../core/theme/constants.dart';
import '../notifiers/notes_notifier.dart';
import '../state/notes_state.dart';

class NoteEditorPage extends HookConsumerWidget {
  const NoteEditorPage({
    super.key,
    this.noteId,
  });

  final String? noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final titleController = useTextEditingController();
    final contentController = useTextEditingController();

    final state = ref.watch(notesNotifierProvider);
    final isViewMode = noteId != null;
    final isEditing = useState<bool>(!isViewMode);

    useEffect(() {
      if (noteId != null) {
        Future.microtask(() => ref.read(notesNotifierProvider.notifier).selectNoteById(noteId!));
      } else {
        Future.microtask(() => ref.read(notesNotifierProvider.notifier).clearSelectedNote());
      }

      return null;
    }, [noteId]);

    useEffect(() {
      if (state is NotesLoaded && state.selectedNote != null && !isEditing.value) {
        final note = state.selectedNote!;
        titleController.text = note.title;
        contentController.text = note.content;
      }
      return null;
    }, [state, isEditing.value]);

    Future<void> save() async {
      final title = titleController.text.trim();
      final content = contentController.text.trim();

      if (content.isEmpty && title.isEmpty) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Write something first.')));
        return;
      }

      if (isViewMode) {
        if (!isEditing.value || noteId == null) return;

        final updated = await ref.read(notesNotifierProvider.notifier).updateNote(
              noteId: noteId!,
              title: title,
              content: content,
            );

        if (updated != null && context.mounted) {
          isEditing.value = false;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Note updated')));
        }
      } else {
        final created = await ref.read(notesNotifierProvider.notifier).createNote(
              title: title,
              content: content,
            );

        if (created != null && context.mounted) {
          context.go(RouteConstants.notes.toPath);
        }
      }
    }

    final selectedNote = state is NotesLoaded ? state.selectedNote : null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: Constants.paddingAllMedium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.go(RouteConstants.notes.toPath),
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Back',
                  ),
                  Expanded(
                    child: Text(
                      isViewMode
                          ? (isEditing.value ? 'Edit note' : 'View note')
                          : 'Create note',
                      style: textTheme.headlineSmall,
                    ),
                  ),
                  if (isViewMode)
                    IconButton(
                      onPressed: () {
                        isEditing.value = !isEditing.value;
                      },
                      icon: Icon(isEditing.value ? Icons.visibility : Icons.edit),
                      tooltip: isEditing.value ? 'View' : 'Edit',
                    ),
                  TextButton(
                    onPressed: (state is NotesLoading)
                        ? null
                        : () {
                            if (isViewMode && !isEditing.value) {
                              isEditing.value = true;
                              return;
                            }
                            save();
                          },
                    child: Text(
                      isViewMode ? (isEditing.value ? 'Save' : 'Edit') : 'Create',
                      style: textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
              Space.verticalMedium,
              if (isViewMode && state is NotesLoading)
                const LinearProgressIndicator(minHeight: 2),
              if (isViewMode && state is NotesError)
                Padding(
                  padding: Constants.paddingVerticalSmall,
                  child: Text(
                    (state as NotesError).message,
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (isViewMode && selectedNote == null && state is NotesLoaded)
                Padding(
                  padding: Constants.paddingVerticalSmall,
                  child: Text(
                    'Note not found.',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: titleController,
                        enabled: !isViewMode || isEditing.value,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Space.verticalMedium,
                      TextField(
                        controller: contentController,
                        enabled: !isViewMode || isEditing.value,
                        minLines: 8,
                        maxLines: 14,
                        decoration: const InputDecoration(
                          labelText: 'Content',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Space.verticalMedium,
                      if (isViewMode && selectedNote != null)
                        Text(
                          'Updated: ${selectedNote.updatedAt}',
                          style: textTheme.labelSmall,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
