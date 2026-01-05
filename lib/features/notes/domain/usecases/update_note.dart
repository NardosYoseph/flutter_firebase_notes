import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

final class UpdateNote {
  const UpdateNote(this._repository);

  final NotesRepository _repository;

  Future<NoteEntity> call({
    required String noteId,
    required String title,
    required String content,
  }) {
    return _repository.updateNote(
      noteId: noteId,
      title: title,
      content: content,
    );
  }
}
