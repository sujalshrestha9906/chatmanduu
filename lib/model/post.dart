class Like {
  final int likes;
  final List<String> usernames;
  Like({required this.likes, required this.usernames});
}

class Comment {
  final String userName;
  final String imageUrl;
  final String comment;

  Comment(
      {required this.imageUrl, required this.comment, required this.userName});
}

class Post {
  final String postId;
  final String userId;
  final String title;
  final String detail;
  final String imageUrl;
  final Like like;
  final List<Comment> comments;

  Post(
      {required this.like,
      required this.imageUrl,
      required this.userId,
      required this.comments,
      required this.detail,
      required this.postId,
      required this.title});
}
