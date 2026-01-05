import '../entities/note_entity.dart';
import '../repositories/notes_repository.dart';

final class WatchNotes {
  const WatchNotes(this._repository);

  final NotesRepository _repository;

  Stream<List<NoteEntity>> call() => _repository.watchNotes();
}
