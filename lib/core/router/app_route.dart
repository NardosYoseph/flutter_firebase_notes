import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'route_constants.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notes/presentation/pages/note_editor_page.dart';
import '../../features/notes/presentation/pages/notes_list_page.dart';

final GoRouter router = GoRouter(
  
  initialLocation: RouteConstants.login.toPath,
  debugLogDiagnostics: true,

  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final location = state.matchedLocation;

    final isLoginRoute = location == RouteConstants.login.toPath;
    final isSignUpRoute = location == RouteConstants.signUp.toPath;
    final isAuthRoute = isLoginRoute || isSignUpRoute;

    if (!isLoggedIn && !isAuthRoute) {
      return RouteConstants.login.toPath;
    }

    if (isLoggedIn && isAuthRoute) {
      return RouteConstants.notes.toPath;
    }

    return null;
  },
  errorBuilder: (context, state) => Container(),
 
  routes: [
    GoRoute(
      path: RouteConstants.login.toPath,
      name: RouteConstants.login.name,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteConstants.signUp.toPath,
      name: RouteConstants.signUp.name,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: RouteConstants.home.toPath,
      name: RouteConstants.home.name,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: RouteConstants.notes.toPath,
      name: RouteConstants.notes.name,
      builder: (context, state) => const NotesListPage(),
    ),
    GoRoute(
      path: RouteConstants.noteCreate.toPath,
      name: RouteConstants.noteCreate.name,
      builder: (context, state) => const NoteEditorPage(),
    ),
    GoRoute(
      path: RouteConstants.noteEdit.toPath,
      name: RouteConstants.noteEdit.name,
      builder: (context, state) {
        final noteId = state.pathParameters['noteId'];
        return NoteEditorPage(noteId: noteId);
      },
    ),
  ],
);