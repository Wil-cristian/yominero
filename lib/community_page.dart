import 'package:flutter/material.dart';
import 'models/post.dart';
import 'post_detail_page.dart';

/// A community feed page that displays a list of posts. Users can
/// tap on a post to view its details or press the like button to
/// increment the like count. The posts are stored locally in this
/// stateful widget for demonstration purposes.
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Post> _posts = [
    Post(
      id: 'p1',
      title: 'Primer post',
      content:
          'Descripción del primer post. Esta es una publicación de ejemplo.',
      likes: 0,
    ),
    Post(
      id: 'p2',
      title: 'Segundo post',
      content:
          'Otra descripción para mostrar cómo se ven las publicaciones.',
      likes: 0,
    ),
    Post(
      id: 'p3',
      title: 'Tercer post',
      content:
          'Publicación de prueba con texto más largo para ocupar espacio y ver el diseño.',
      likes: 0,
    ),
  ];

  void _likePost(int index) {
    setState(() {
      final post = _posts[index];
      _posts[index] = Post(
        id: post.id,
        title: post.title,
        content: post.content,
        likes: post.likes + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comunidad')),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return ListTile(
            title: Text(post.title),
            subtitle: Text(post.content),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () => _likePost(index),
                ),
                Text('${post.likes}'),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PostDetailPage(post: post),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
