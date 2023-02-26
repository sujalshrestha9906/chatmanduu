class Like {
  final int likes;
  final List<String> usernames;
  Like({required this.likes, required this.usernames});

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
        likes: json['likes'],
        usernames:
            (json['usernames'] as List).map((e) => e as String).toList());
  }
}

class Comment {
  final String userName;
  final String imageUrl;
  final String comment;

  Comment(
      {required this.imageUrl, required this.comment, required this.userName});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        imageUrl: json['imageUrl'],
        comment: json['comment'],
        userName: json['userName']);
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': this.imageUrl,
      'comment': this.comment,
      'userName': this.userName
    };
  }
}

class Post {
  final String postId;
  final String userId;
  final String title;
  final String detail;
  final String imageUrl;
  final String imageId;
  final Like like;
  final List<Comment> comments;

  Post(
      {required this.like,
      required this.imageUrl,
      required this.userId,
      required this.comments,
      required this.detail,
      required this.postId,
      required this.title,
      required this.imageId});
}
