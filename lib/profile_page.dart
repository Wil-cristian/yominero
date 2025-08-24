import 'package:flutter/material.dart';
import 'package:yominero/shared/models/user.dart';
import 'core/auth/auth_service.dart';
import 'package:yominero/shared/models/post.dart';
import 'post_detail_page.dart';
import 'home_page.dart';
import 'core/theme/colors.dart';

/// Simple profile page that displays basic user information and a list
/// of the user's posts. Selecting a post navigates to its detail page.
class ProfilePage extends StatelessWidget {
  final User user;
  final List<Post> posts;

  const ProfilePage({super.key, required this.user, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
        actions: [
          if (user.role == UserRole.admin)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.shield_moon_outlined),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.secondaryContainer.withOpacity(.55),
              backgroundImage:
                  user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
              child: user.avatarUrl == null
                  ? Text(user.username.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold))
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(user.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          Text(user.email),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(label: Text(user.role.name)),
              if (user.phone != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 4),
                Text(user.phone!),
              ]
            ],
          ),
          if (user.bio != null) ...[
            const SizedBox(height: 12),
            Text(
              user.bio!,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
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
                  MaterialPageRoute(builder: (_) => PostDetailPage(post: post)),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              AuthService.instance.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => HomePage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
