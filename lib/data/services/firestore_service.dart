import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/data/models/note_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  CollectionReference? get _notesCollection {
    final userId = _userId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(userId).collection('notes');
  }

  Future<List<NoteModel>> fetchNotes() async {
    try {
      final userId = _userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final querySnapshot = await _notesCollection!
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => NoteModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch notes: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  Future<void> addNote(String title, String content) async {
    try {
      final userId = _userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final now = DateTime.now();
      final note = NoteModel(
        id: '',
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );

      await _notesCollection!.add(note.toFirestore());

    } on FirebaseException catch (e) {
      throw Exception('Failed to add note: ${e.message}');
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  Future<void> updateNote(String id, String title, String content) async {
    try {
      final userId = _userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _notesCollection!.doc(id).update({
        'title': title,
        'content': content,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

    } on FirebaseException catch (e) {
      throw Exception('Failed to update note: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final userId = _userId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _notesCollection!.doc(id).delete();

    } on FirebaseException catch (e) {
      throw Exception('Failed to delete note: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
}
