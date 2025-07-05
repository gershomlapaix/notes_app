import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/data/repositories/note_repository.dart';
import 'package:notes_app/data/services/auth_service.dart';
import 'package:notes_app/data/services/firestore_service.dart';
import 'package:notes_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:notes_app/presentation/bloc/notes/notes_bloc.dart';
import 'package:notes_app/presentation/pages/auth/login_page.dart';
import 'package:notes_app/presentation/pages/notes/notes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthService()),
        ),
        BlocProvider(
          create: (context) => NotesBloc(
            NoteRepository(FirestoreService()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Notes App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          print('✅ User authenticated via StreamBuilder');
          return NotesPage();
        } else {
          print('❌ No user, showing LoginPage');
          return LoginPage();
        }
      },
    );
  }
}



