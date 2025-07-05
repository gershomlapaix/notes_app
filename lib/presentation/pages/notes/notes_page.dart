import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:notes_app/presentation/bloc/auth/auth_event.dart';
import 'package:notes_app/presentation/bloc/notes/notes_bloc.dart';
import 'package:notes_app/presentation/bloc/notes/notes_event.dart';
import 'package:notes_app/presentation/bloc/notes/notes_state.dart';
import 'package:notes_app/presentation/pages/notes/add_edit_note_dialog.dart';
import 'package:notes_app/presentation/widgets/custom_snackbar.dart';
import 'package:notes_app/presentation/widgets/loading_widget.dart';
import 'package:notes_app/presentation/widgets/note_card.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});
  @override
  NotesPageState createState() => NotesPageState();
}

class NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    // Add a small delay to ensure authentication is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.read<NotesBloc>().add(FetchNotes());
      } else {
        CustomSnackBar.showError(context, 'Please sign in to view notes');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes ${user?.email ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (user != null) {
                context.read<NotesBloc>().add(FetchNotes());
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            CustomSnackBar.showError(context, state.message);
          } else if (state is NotesOperationSuccess) {
            CustomSnackBar.showSuccess(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is NotesLoading) {
            return const LoadingWidget();
          } else if (state is NotesLoaded) {
            return _buildNotesList(state.notes);
          } else if (state is NotesOperationSuccess) {
            return _buildNotesList(state.notes);
          } else if (state is NotesError) {
            return _buildErrorState(state.message);
          } else {
            return _buildEmptyState();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: user != null ? () => _showAddNoteDialog(context) : null,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNotesList(List notes) {
    if (notes.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onEdit: () => _showEditNoteDialog(context, note),
          onDelete: () => _showDeleteConfirmation(context, note.id),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nothing here yet—tap ➕ to add a note.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<NotesBloc>().add(FetchNotes()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddEditNoteDialog(),
    );
  }

  void _showEditNoteDialog(BuildContext context, note) {
    showDialog(
      context: context,
      builder: (context) => AddEditNoteDialog(note: note),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<NotesBloc>().add(DeleteNote(id: noteId));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
