import 'user.dart';

class Post {
  int? id;
  String? tag;
  String? video;
  int? likesCount;
  int? commentsCount;
  User? user;
  bool? selfLiked;

  Post({
    this.id,
    this.tag,
    this.video,
    this.likesCount,
    this.commentsCount,
    this.user,
    this.selfLiked,
  });

  // map json to post model
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      tag: json['tag'],
      video: json['video'],
      likesCount: json['likes_count'],
      commentsCount: json['comments_count'],
      selfLiked: json['likes'].length > 0,
      user: User.fromJson(json['user']),
    );
  }
}
