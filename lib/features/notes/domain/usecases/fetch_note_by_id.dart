import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

final class FetchNoteById {
  const FetchNoteById(this._repository);

  final NotesRepository _repository;

  Future<NoteEntity?> call(String noteId) => _repository.fetchNoteById(noteId);
}
