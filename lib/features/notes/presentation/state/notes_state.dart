import '../../domain/entities/note_entity.dart';

sealed class NotesState {
  const NotesState();
}

final class NotesInit extends NotesState {
  const NotesInit();
}

final class NotesLoading extends NotesState {
  const NotesLoading();
}

final class NotesLoaded extends NotesState {
  const NotesLoaded({
    required this.notes,
    this.selectedNote,
  });

  final List<NoteEntity> notes;
  final NoteEntity? selectedNote;
}

final class NotesError extends NotesState {
  const NotesError(this.message);

  final String message;
}
