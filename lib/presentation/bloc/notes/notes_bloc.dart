import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/data/repositories/note_repository.dart';
import 'package:notes_app/presentation/bloc/notes/notes_event.dart';
import 'package:notes_app/presentation/bloc/notes/notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository _noteRepository;

  NotesBloc(this._noteRepository) : super(NotesInitial()) {
    on<FetchNotes>(_onFetchNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onFetchNotes(
      FetchNotes event,
      Emitter<NotesState> emit,
      ) async {
    emit(NotesLoading());
    try {
      final notes = await _noteRepository.fetchNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onAddNote(
      AddNote event,
      Emitter<NotesState> emit,
      ) async {
    try {
      await _noteRepository.addNote(event.title, event.content);
      final notes = await _noteRepository.fetchNotes();
      emit(NotesOperationSuccess(
        message: 'Note added successfully',
        notes: notes,
      ));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onUpdateNote(
      UpdateNote event,
      Emitter<NotesState> emit,
      ) async {
    try {
      await _noteRepository.updateNote(event.id, event.title, event.content);
      final notes = await _noteRepository.fetchNotes();
      emit(NotesOperationSuccess(
        message: 'Note updated successfully',
        notes: notes,
      ));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onDeleteNote(
      DeleteNote event,
      Emitter<NotesState> emit,
      ) async {
    try {
      await _noteRepository.deleteNote(event.id);
      final notes = await _noteRepository.fetchNotes();
      emit(NotesOperationSuccess(
        message: 'Note deleted successfully',
        notes: notes,
      ));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }
}