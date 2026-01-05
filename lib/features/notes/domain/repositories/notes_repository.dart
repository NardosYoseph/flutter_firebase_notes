import '../entities/note_entity.dart';

abstract interface class NotesRepository {
  Future<NoteEntity> createNote({
    required String title,
    required String content,
  });

  Future<NoteEntity> updateNote({
    required String noteId,
    required String title,
    required String content,
  });

  Future<List<NoteEntity>> fetchNotes();

  Stream<List<NoteEntity>> watchNotes();

  Future<NoteEntity?> fetchNoteById(String noteId);

  Future<void> deleteNote(String noteId);
}
