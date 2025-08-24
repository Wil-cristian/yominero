import 'package:flutter/material.dart';
import 'package:yominero/shared/models/user.dart';
import 'package:yominero/shared/models/post.dart';
import 'post_detail_page.dart';

/// Simple profile page that displays basic user information and a list
/// of the user's posts. Selecting a post navigates to its detail page.
class ProfilePage extends StatelessWidget {
  final User user;
  final List<Post> posts;

  const ProfilePage({super.key, required this.user, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.username)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(user.email),
          const SizedBox(height: 24),
          const Text(
            'Publicaciones:',
            style: TextStyle(fontSize: 18),
          ),
          ...posts.map(
            (post) => ListTile(
              title: Text(post.title),
              subtitle: Text(post.content),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PostDetailPage(post: post),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
