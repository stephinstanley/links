import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/link.dart';
import '../models/tag.dart';

/// Data Provider Layer - Handles raw Firebase operations
/// SIMPLIFIED: Only reads tags and links
class LinksDataProvider {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  LinksDataProvider({FirebaseFirestore? firestore, FirebaseAuth? firebaseAuth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Get current user ID
  String? get _currentUserId => _firebaseAuth.currentUser?.uid;

  /// Stream of user's tags
  Stream<List<Tag>> getUserTagsStream() {
    final userId = _currentUserId?.trim();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    return _firestore
        .collection('tags')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final tags = snapshot.docs
              .map(
                (doc) => Tag(
                  id: doc.id,
                  tagName: doc['tagName'] as String? ?? '',
                  userId: userId,
                ),
              )
              .where((tag) => tag.tagName.isNotEmpty)
              .toList();
          return tags;
        });
  }

  /// Stream of user's links
  Stream<List<Link>> getUserLinksStream() {
    final userId = _currentUserId?.trim();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    try {
      final query = _firestore
          .collection('links')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true);

      return query.snapshots().map((snapshot) {
        try {
          final links = _parseLinks(snapshot);
          return links;
        } catch (e, st) {
          log('DataProvider: parse error: $e', stackTrace: st);
          throw Exception('Failed to parse links: $e');
        }
      });
    } catch (e, st) {
      log('DataProvider: query error: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Helper method to parse Firestore documents into Link objects
  List<Link> _parseLinks(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final ts = data['createdAt'];

      DateTime createdAt;
      if (ts is Timestamp) {
        createdAt = ts.toDate();
      } else {
        createdAt = DateTime.now();
      }

      final link = Link(
        id: doc.id,
        title: data['title'] ?? '',
        url: data['url'] ?? '',
        createdAt: createdAt,
        tag: (data['tag'] ?? 'default').toString().trim(),
      );

      return link;
    }).toList();
  }

  /// Add a new link to Firestore
  Future<void> addLink({
    required String title,
    required String url,
    required String tag,
  }) async {
    final userId = _currentUserId?.trim();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore.collection('links').add({
        'userId': userId,
        'title': title.trim(),
        'url': url.trim(),
        'tag': tag.trim(),
        'createdAt': Timestamp.now(),
      });
      log('DataProvider: Link added successfully');
    } catch (e, st) {
      log('DataProvider: Failed to add link: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Update an existing link in Firestore
  Future<void> updateLink({
    required String linkId,
    required String title,
    required String url,
    required String tag,
  }) async {
    final userId = _currentUserId?.trim();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore.collection('links').doc(linkId).update({
        'title': title.trim(),
        'url': url.trim(),
        'tag': tag.trim(),
        'updatedAt': Timestamp.now(),
      });
      log('DataProvider: Link updated successfully');
    } catch (e, st) {
      log('DataProvider: Failed to update link: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Delete a link from Firestore
  Future<void> deleteLink({required String linkId}) async {
    final userId = _currentUserId?.trim();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore.collection('links').doc(linkId).delete();
      log('DataProvider: Link deleted successfully');
    } catch (e, st) {
      log('DataProvider: Failed to delete link: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Add a new tag
  Future<void> addTag({required String tagName}) async {
    final userId = _currentUserId?.trim();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    try {
      await _firestore.collection('tags').add({
        'userId': userId,
        'tagName': tagName.trim(),
        'createdAt': Timestamp.now(),
      });
      log('DataProvider: Tag added successfully');
    } catch (e, st) {
      log('DataProvider: Failed to add tag: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Edit a tag (rename)
  Future<void> editTag({
    required String tagId,
    required String newTagName,
  }) async {
    final userId = _currentUserId?.trim();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    try {
      final normalizedNewTagName = newTagName.trim();

      // Update the tag directly by ID
      await _firestore.collection('tags').doc(tagId).update({
        'tagName': normalizedNewTagName,
        'updatedAt': Timestamp.now(),
      });

      log('DataProvider: Tag updated successfully');
    } catch (e, st) {
      log('DataProvider: Failed to update tag: $e', stackTrace: st);
      rethrow;
    }
  }

  /// Delete a tag
  Future<void> deleteTag({required String tagId}) async {
    final userId = _currentUserId?.trim();
    if (userId == null || userId.isEmpty) {
      throw Exception('User not authenticated');
    }

    try {
      // Delete the tag directly by ID
      await _firestore.collection('tags').doc(tagId).delete();

      log('DataProvider: Tag deleted successfully');
    } catch (e, st) {
      log('DataProvider: Failed to delete tag: $e', stackTrace: st);
      rethrow;
    }
  }
}
