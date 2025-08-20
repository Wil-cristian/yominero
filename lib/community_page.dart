import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Map<String, dynamic>> _posts = [
    {
      'title': 'Primer post',
      'content': 'Descripci\u00f3n del primer post. Esta es una publicaci\u00f3n de ejemplo.',
      'likes': 0,
    },
    {
      'title': 'Segundo post',
      'content': 'Otra descripci\u00f3n para mostrar c\u00f3mo se ver\u00e1n las publicaciones.',
      'likes': 0,
    },
    {
      'title': 'Tercer post',
      'content': 'Publicaci\u00f3n de prueba con texto m\u00e1s largo para ocupar espacio y ver el dise\u00f1o.',
      'likes': 0,
    },
  ];

  void _likePost(int index) {
    setState(() {
      _posts[index]['likes'] = _posts[index]['likes'] + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                    const SizedBox(height: 4.0),
                  Text(post['content']),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up),
                        onPressed: () => _likePost(index),
                      ),
                      Text('${post['likes']}'),
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () {
                          // TODO: Navegar a la pantalla de comentarios
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark),
                        onPressed: () {
                          // TODO: Guardar la publicaci\u00f3n en favoritos
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navegar a la pantalla para crear una nueva publicaci\u00f3n
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
