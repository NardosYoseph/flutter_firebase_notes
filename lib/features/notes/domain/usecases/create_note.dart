import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

final class CreateNote {
  const CreateNote(this._repository);

  final NotesRepository _repository;

  Future<NoteEntity> call({
    required String title,
    required String content,
  }) {
    return _repository.createNote(
      title: title,
      content: content,
    );
  }
}
