import 'package:flutter/material.dart';
import 'package:yominero/shared/models/post.dart';

/// Page that displays the full content of a post and allows users
/// to increment the like count. In a real application the likes
/// would be persisted and tied to a user account.
class PostDetailPage extends StatefulWidget {
  final Post post;
  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late int _likes;

  @override
  void initState() {
    super.initState();
    _likes = widget.post.likes;
  }

  void _toggleLike() {
    setState(() {
      _likes += 1;
    });
    // In a full application you would send this update to a backend.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.post.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.content,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: _toggleLike,
                ),
                Text('Likes: $_likes'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
