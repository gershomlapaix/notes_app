import 'package:notes_app/data/models/note_model.dart';
import 'package:notes_app/data/services/firestore_service.dart';

class NoteRepository {
  final FirestoreService _firestoreService;

  NoteRepository(this._firestoreService);

  Future<List<NoteModel>> fetchNotes() async {
    return await _firestoreService.fetchNotes();
  }

  Future<void> addNote(String title, String content) async {
    await _firestoreService.addNote(title, content);
  }

  Future<void> updateNote(String id, String title, String content) async {
    await _firestoreService.updateNote(id, title, content);
  }

  Future<void> deleteNote(String id) async {
    await _firestoreService.deleteNote(id);
  }
}
