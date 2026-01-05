import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/note_entity.dart';
import '../providers/notes_usecases_providers.dart';
import '../state/notes_state.dart';

part 'notes_notifier.g.dart';

@riverpod
class NotesNotifier extends _$NotesNotifier {
  StreamSubscription<List<NoteEntity>>? _sub;

  @override
  NotesState build() {
    ref.onDispose(() async {
      await _sub?.cancel();
      _sub = null;
    });

    state = const NotesLoading();
    _startWatching();

    return const NotesInit();
  }

  void _startWatching() {
    _sub?.cancel();

    _sub = ref.read(watchNotesUseCaseProvider).call().listen(
      (notes) {
        final selected = state is NotesLoaded ? (state as NotesLoaded).selectedNote : null;
        state = NotesLoaded(notes: notes, selectedNote: selected);
      },
      onError: (Object err, StackTrace st) {
        state = NotesError(err.toString());
      },
    );
  }

  Future<void> refresh() async {
    state = const NotesLoading();
    try {
      final notes = await ref.read(fetchNotesUseCaseProvider).call();
      final selected = state is NotesLoaded ? (state as NotesLoaded).selectedNote : null;
      state = NotesLoaded(notes: notes, selectedNote: selected);
    } catch (e) {
      state = NotesError(e.toString());
    }
  }

  Future<void> selectNoteById(String noteId) async {
    final prevNotes = state is NotesLoaded ? (state as NotesLoaded).notes : const <NoteEntity>[];
    state = const NotesLoading();

    try {
      final note = await ref.read(fetchNoteByIdUseCaseProvider).call(noteId);
      state = NotesLoaded(notes: prevNotes, selectedNote: note);
    } catch (e) {
      state = NotesError(e.toString());
    }
  }

  void clearSelectedNote() {
    if (state is NotesLoaded) {
      final s = state as NotesLoaded;
      state = NotesLoaded(notes: s.notes, selectedNote: null);
    }
  }

  Future<NoteEntity?> createNote({
    required String title,
    required String content,
  }) async {
    try {
      final created = await ref.read(createNoteUseCaseProvider).call(
            title: title,
            content: content,
          );
      return created;
    } catch (e) {
      state = NotesError(e.toString());
      return null;
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await ref.read(deleteNoteUseCaseProvider).call(noteId);

      if (state is NotesLoaded) {
        final s = state as NotesLoaded;
        final updatedNotes = s.notes.where((n) => n.id != noteId).toList(growable: false);
        final selected = (s.selectedNote?.id == noteId) ? null : s.selectedNote;
        state = NotesLoaded(notes: updatedNotes, selectedNote: selected);
      }
    } catch (e) {
      state = NotesError(e.toString());
    }
  }

  Future<NoteEntity?> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    try {
      final updated = await ref.read(updateNoteUseCaseProvider).call(
            noteId: noteId,
            title: title,
            content: content,
          );

      if (state is NotesLoaded) {
        final s = state as NotesLoaded;
        final List<NoteEntity> updatedNotes = s.notes
            .map<NoteEntity>((n) => n.id == updated.id ? updated : n)
            .toList(growable: false);

        final selected = (s.selectedNote?.id == updated.id) ? updated : s.selectedNote;
        state = NotesLoaded(notes: updatedNotes, selectedNote: selected);
      }

      return updated;
    } catch (e) {
      state = NotesError(e.toString());
      return null;
    }
  }
}
