enum RouteConstants {
  login,
  signUp,
  home,
  favorites,
  notes,
  noteCreate,
  noteEdit;
}

extension RouteConstantsX on RouteConstants {
  String get toPath {
    switch (this) {
      case RouteConstants.login:
        return '/login';
      case RouteConstants.signUp:
        return '/signup';
      case RouteConstants.home:
        return '/home';
      case RouteConstants.favorites:
        return '/favorites';
      case RouteConstants.notes:
        return '/notes';
      case RouteConstants.noteCreate:
        return '/notes/create';
      case RouteConstants.noteEdit:
        return '/notes/:noteId/edit';
    }
  }
}
