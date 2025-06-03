import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/forum_post.dart';

class ForumService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ForumPost>> getPosts() {
    return _firestore
        .collection('forum_posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ForumPost.fromJson(data);
      }).toList();
    });
  }

  Future<void> createPost(
      String userId, String userName, String content) async {
    await _firestore.collection('forum_posts').add({
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'replyCount': 0,
    });
  }

  Future<void> addReply(
    String postId,
    String userId,
    String userName,
    String content,
  ) async {
    final batch = _firestore.batch();
    final postRef = _firestore.collection('forum_posts').doc(postId);
    final replyRef = postRef.collection('replies').doc();

    // Add reply
    batch.set(replyRef, {
      'id': replyRef.id,
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Increment reply count
    batch.update(postRef, {
      'replyCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  Stream<List<ForumReply>> getReplies(String postId) {
    return _firestore
        .collection('forum_posts')
        .doc(postId)
        .collection('replies')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ForumReply.fromJson(data);
      }).toList();
    });
  }
}
