import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/notes_repository.dart';
import '../data_source/notes_remote_data_source.dart';
import '../models/note.dart';

part 'notes_repository_impl.g.dart';

final class NotesRepositoryImpl implements NotesRepository {
  NotesRepositoryImpl(this._remote);

  final NotesRemoteDataSource _remote;

  @override
  Future<NoteEntity> createNote({
    required String title,
    required String content,
  }) async {
    final note = await _remote.createNote(
      title: title,
      content: content,
    );

    return _toEntity(note);
  }

  @override
  Future<NoteEntity> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    final note = await _remote.updateNote(
      noteId: noteId,
      title: title,
      content: content,
    );
    return _toEntity(note);
  }

  @override
  Future<List<NoteEntity>> fetchNotes() async {
    final notes = await _remote.fetchNotes();
    return notes.map(_toEntity).toList(growable: false);
  }

  @override
  Stream<List<NoteEntity>> watchNotes() {
    return _remote.watchNotes().map(
          (notes) => notes.map(_toEntity).toList(growable: false),
        );
  }

  @override
  Future<NoteEntity?> fetchNoteById(String noteId) async {
    final note = await _remote.fetchNoteById(noteId);
    if (note == null) return null;
    return _toEntity(note);
  }

  @override
  Future<void> deleteNote(String noteId) {
    return _remote.deleteNote(noteId);
  }

  NoteEntity _toEntity(Note note) {
    return NoteEntity(
      id: note.id,
      userId: note.userId,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
    );
  }
}

@riverpod
NotesRepository notesRepository(Ref ref) {
  return NotesRepositoryImpl(ref.watch(notesRemoteDataSourceProvider));
}
