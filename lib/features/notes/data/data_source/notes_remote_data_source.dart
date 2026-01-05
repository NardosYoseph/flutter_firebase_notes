
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/firebase_providers.dart';
import '../models/note.dart';

part 'notes_remote_data_source.g.dart';

final class NotesRemoteDataSource {
  NotesRemoteDataSource(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _notesCollection {
    return _firestore.collection('notes');
  }

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('User is not authenticated');
    }
    return user.uid;
  }

  Future<Note> createNote({
    required String title,
    required String content,
  }) async {
    final now = DateTime.now();

    final data = <String, dynamic>{
      'userId': _userId,
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    };

    final doc = await _notesCollection.add(data);

    return Note.fromJson({...data, 'id': doc.id});
  }

  Future<List<Note>> fetchNotes() async {
    final snap = await _notesCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('updatedAt', descending: true)
        .get();

    return snap.docs.map(_noteFromDoc).toList(growable: false);
  }

  Stream<List<Note>> watchNotes() {
    return _notesCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(_noteFromDoc).toList(growable: false));
  }

  Future<Note?> fetchNoteById(String noteId) async {
    final doc = await _notesCollection.doc(noteId).get();
    if (!doc.exists) return null;

    final note = _noteFromDoc(doc);
    if (note.userId != _userId) {
      throw StateError('Access denied');
    }
    return note;
  }

  Future<void> deleteNote(String noteId) async {
    final doc = await _notesCollection.doc(noteId).get();
    if (!doc.exists) return;

    final note = _noteFromDoc(doc);
    if (note.userId != _userId) {
      throw StateError('Access denied');
    }

    await _notesCollection.doc(noteId).delete();
  }

  Future<Note> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    final doc = await _notesCollection.doc(noteId).get();
    if (!doc.exists) {
      throw StateError('Note not found');
    }

    final existing = _noteFromDoc(doc);
    if (existing.userId != _userId) {
      throw StateError('Access denied');
    }

    final now = DateTime.now();
    final patch = <String, dynamic>{
      'title': title,
      'content': content,
      'updatedAt': Timestamp.fromDate(now),
    };

    await _notesCollection.doc(noteId).update(patch);

    return existing.copyWith(
      title: title,
      content: content,
      updatedAt: now,
    );
  }

  Note _noteFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Note document has no data');
    }
    return Note.fromJson({...data, 'id': doc.id});
  }
}

@riverpod
NotesRemoteDataSource notesRemoteDataSource(Ref ref) {
  return NotesRemoteDataSource(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  );
}
