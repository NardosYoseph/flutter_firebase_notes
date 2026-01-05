import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

final class FetchNotes {
  const FetchNotes(this._repository);

  final NotesRepository _repository;

  Future<List<NoteEntity>> call() => _repository.fetchNotes();
}
