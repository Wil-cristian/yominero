class Post {
  final String id;
  final String title;
  final String content;
  final int likes;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.likes = 0,
  });
}
