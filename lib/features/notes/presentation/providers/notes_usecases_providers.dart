import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/notes_repository_impl.dart';
import '../../domain/usecases/create_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/fetch_note_by_id.dart';
import '../../domain/usecases/fetch_notes.dart';
import '../../domain/usecases/update_note.dart';
import '../../domain/usecases/watch_notes.dart';

part 'notes_usecases_providers.g.dart';

@riverpod
CreateNote createNoteUseCase(Ref ref) {
  return CreateNote(ref.watch(notesRepositoryProvider));
}

@riverpod
FetchNotes fetchNotesUseCase(Ref ref) {
  return FetchNotes(ref.watch(notesRepositoryProvider));
}

@riverpod
WatchNotes watchNotesUseCase(Ref ref) {
  return WatchNotes(ref.watch(notesRepositoryProvider));
}

@riverpod
FetchNoteById fetchNoteByIdUseCase(Ref ref) {
  return FetchNoteById(ref.watch(notesRepositoryProvider));
}

@riverpod
DeleteNote deleteNoteUseCase(Ref ref) {
  return DeleteNote(ref.watch(notesRepositoryProvider));
}

@riverpod
UpdateNote updateNoteUseCase(Ref ref) {
  return UpdateNote(ref.watch(notesRepositoryProvider));
}
