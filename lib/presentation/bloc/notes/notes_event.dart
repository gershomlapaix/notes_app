import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class FetchNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final String title;
  final String content;

  const AddNote({required this.title, required this.content});

  @override
  List<Object> get props => [title, content];
}

class UpdateNote extends NotesEvent {
  final String id;
  final String title;
  final String content;

  const UpdateNote({
    required this.id,
    required this.title,
    required this.content,
  });

  @override
  List<Object> get props => [id, title, content];
}

class DeleteNote extends NotesEvent {
  final String id;

  const DeleteNote({required this.id});

  @override
  List<Object> get props => [id];
}
