// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../models/movie_model.dart';
//
// abstract class UserMoviesRemoteDataSource {
//   Future<void> toggleWatchlist(MovieModel movie);
//
//   Future<void> addToHistory(MovieModel movie);
//
//   Stream<bool> isMovieInWatchlist(int movieId);
// }
//
// class UserMoviesRemoteDataSourceImpl implements UserMoviesRemoteDataSource {
//   final FirebaseAuth _auth;
//   final FirebaseFirestore _firestore;
//
//   UserMoviesRemoteDataSourceImpl(this._auth, this._firestore);
//
//   DocumentReference<Map<String, dynamic>> _userDocument(String uid) {
//     return _firestore.collection('Users').doc(uid);
//   }
//
//   @override
//   Future<void> toggleWatchlist(MovieModel movie) async {
//     final user = _auth.currentUser;
//     if (user == null) throw StateError('Please sign in to use your watchlist.');
//
//     final userDocument = _userDocument(user.uid);
//     final snapshot = await userDocument.get();
//     final watchlist = List<Map<String, dynamic>>.from(
//       (snapshot.data()?['watchlist'] as List<dynamic>? ?? const []).map(
//         (item) => Map<String, dynamic>.from(item as Map),
//       ),
//     );
//     final existingMovie = watchlist.where((item) => item['id'] == movie.id);
//
//     if (existingMovie.isNotEmpty) {
//       await userDocument.update({
//         'watchlist': FieldValue.arrayRemove([existingMovie.first]),
//       });
//       return;
//     }
//
//     await userDocument.set({
//       'watchlist': FieldValue.arrayUnion([_toFirestore(movie)]),
//     }, SetOptions(merge: true));
//   }
//
//   @override
//   Future<void> addToHistory(MovieModel movie) async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw StateError('Please sign in to save viewing history.');
//     }
//
//     await _userDocument(user.uid).set({
//       'history': FieldValue.arrayUnion([_toFirestore(movie)]),
//     }, SetOptions(merge: true));
//   }
//
//   @override
//   Stream<bool> isMovieInWatchlist(int movieId) {
//     final user = _auth.currentUser;
//     if (user == null) return Stream.value(false);
//
//     return _userDocument(user.uid).snapshots().map((snapshot) {
//       final watchlist =
//           snapshot.data()?['watchlist'] as List<dynamic>? ?? const [];
//       return watchlist.any(
//         (item) => (item as Map<String, dynamic>)['id'] == movieId,
//       );
//     });
//   }
//
//   Map<String, dynamic> _toFirestore(MovieModel movie) => {
//     'id': movie.id,
//     'title': movie.title,
//     'rating': movie.rating,
//     'image_url': movie.coverImage,
//     'poster_path': movie.coverImage,
//     'medium_cover_image': movie.coverImage,
//   };
// }
