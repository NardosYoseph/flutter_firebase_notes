import '../repositories/notes_repository.dart';

final class DeleteNote {
  const DeleteNote(this._repository);

  final NotesRepository _repository;

  Future<void> call(String noteId) => _repository.deleteNote(noteId);
}
