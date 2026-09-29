import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/stream_extensions.dart';
import '../models/movie_model.dart';

abstract class UserMoviesRemoteDataSource {
  Future<void> toggleWatchlist(MovieModel movie);

  Future<void> addToHistory(MovieModel movie);

  Stream<bool> isMovieInWatchlist(int movieId);

  /// The signed-in user's watchlist, most recently added first.
  Stream<List<MovieModel>> watchWatchlist();

  /// The signed-in user's viewing history, most recently viewed first.
  Stream<List<MovieModel>> watchHistory();
}

class UserMoviesRemoteDataSourceImpl implements UserMoviesRemoteDataSource {
  static const String _watchlistField = 'watchlist';
  static const String _historyField = 'history';

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserMoviesRemoteDataSourceImpl(this._auth, this._firestore);

  DocumentReference<Map<String, dynamic>> _userDocument(String uid) {
    return _firestore.collection('Users').doc(uid);
  }

  @override
  Future<void> toggleWatchlist(MovieModel movie) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Please sign in to use your watchlist.');

    final userDocument = _userDocument(user.uid);
    final snapshot = await userDocument.get();
    final watchlist = _readItems(snapshot.data(), _watchlistField);
    final existingMovie = watchlist.where((item) => item['id'] == movie.id);

    if (existingMovie.isNotEmpty) {
      await userDocument.update({
        _watchlistField: FieldValue.arrayRemove([existingMovie.first]),
      });
      return;
    }

    await userDocument.set({
      _watchlistField: FieldValue.arrayUnion([_toFirestore(movie)]),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> addToHistory(MovieModel movie) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Please sign in to save viewing history.');
    }

    // Re-watching a movie moves it to the end (= most recent) of the list
    // instead of being ignored as a duplicate.
    final userDocument = _userDocument(user.uid);
    final snapshot = await userDocument.get();
    final history = _readItems(snapshot.data(), _historyField)
      ..removeWhere((item) => item['id'] == movie.id)
      ..add(_toFirestore(movie));

    await userDocument.set({_historyField: history}, SetOptions(merge: true));
  }

  @override
  Stream<bool> isMovieInWatchlist(int movieId) {
    return watchWatchlist().map(
      (movies) => movies.any((movie) => movie.id == movieId),
    );
  }

  @override
  Stream<List<MovieModel>> watchWatchlist() => _watchField(_watchlistField);

  @override
  Stream<List<MovieModel>> watchHistory() => _watchField(_historyField);

  Stream<List<MovieModel>> _watchField(String field) {
    return _auth.authStateChanges().switchMap((user) {
      if (user == null) return Stream.value(const <MovieModel>[]);

      return _userDocument(user.uid).snapshots().map(
        (snapshot) => _readItems(
          snapshot.data(),
          field,
        ).map(_fromFirestore).toList().reversed.toList(),
      );
    });
  }

  List<Map<String, dynamic>> _readItems(
    Map<String, dynamic>? data,
    String field,
  ) {
    final items = data?[field] as List<dynamic>? ?? const [];
    return items
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  MovieModel _fromFirestore(Map<String, dynamic> item) {
    return MovieModel(
      id: (item['id'] as num?)?.toInt(),
      title: item['title'] as String?,
      rating: (item['rating'] as num?)?.toDouble(),
      mediumCoverImage:
          (item['medium_cover_image'] ??
                  item['poster_path'] ??
                  item['image_url'])
              as String?,
    );
  }

  Map<String, dynamic> _toFirestore(MovieModel movie) => {
    'id': movie.id,
    'title': movie.title,
    'rating': movie.rating,
    'image_url': movie.coverImage,
    'poster_path': movie.coverImage,
    'medium_cover_image': movie.coverImage,
  };
}
