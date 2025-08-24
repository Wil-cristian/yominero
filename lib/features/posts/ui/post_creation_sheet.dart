import 'package:flutter/material.dart';
import 'package:yominero/shared/models/post.dart';
import 'package:yominero/core/posts/post_validation.dart';

typedef PostCreatedCallback = void Function(Post post);

class PostCreationSheet extends StatefulWidget {
  final Future<Post> Function({
    required String author,
    required String title,
    required String content,
    PostType type,
    List<String> tags,
    List<String> categories,
    List<String>? requiredTags,
    double? budgetAmount,
    String? budgetCurrency,
    DateTime? deadline,
    String? serviceName,
    List<String>? serviceTags,
    double? pricingFrom,
    double? pricingTo,
    String? pricingUnit,
    String? availability,
  }) create;
  final String authorName;
  final PostCreatedCallback onCreated;
  const PostCreationSheet({
    super.key,
    required this.create,
    required this.authorName,
    required this.onCreated,
  });

  @override
  State<PostCreationSheet> createState() => _PostCreationSheetState();
}

class _PostCreationSheetState extends State<PostCreationSheet> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _pricingFromCtrl = TextEditingController();
  final _pricingToCtrl = TextEditingController();
  PostType _type = PostType.community;
  bool _submitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _tagsCtrl.dispose();
    _budgetCtrl.dispose();
    _pricingFromCtrl.dispose();
    _pricingToCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty || content.isEmpty) {
      _show('Completa título y contenido.');
      return;
    }
    if (_type == PostType.request) {
      final err = PostCreationValidator.validateRequestBudget(_budgetCtrl.text);
      if (err != null) {
        _show(err);
        return;
      }
    }
    if (_type == PostType.offer) {
      final err = PostCreationValidator.validateOfferPricing(
          _pricingFromCtrl.text, _pricingToCtrl.text);
      if (err != null) {
        _show(err);
        return;
      }
    }
    final tags = _tagsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    setState(() => _submitting = true);
    try {
      final post = await widget.create(
        author: widget.authorName,
        title: title,
        content: content,
        type: _type,
        tags: tags,
        categories: const [],
        requiredTags: _type == PostType.request ? tags : null,
        budgetAmount: _type == PostType.request
            ? double.tryParse(_budgetCtrl.text)
            : null,
        budgetCurrency: _type == PostType.request ? 'USD' : null,
        serviceName: _type == PostType.offer ? title : null,
        serviceTags: _type == PostType.offer ? tags : null,
        pricingFrom: _type == PostType.offer
            ? double.tryParse(_pricingFromCtrl.text)
            : null,
        pricingTo: _type == PostType.offer
            ? double.tryParse(_pricingToCtrl.text)
            : null,
        pricingUnit: _type == PostType.offer ? 'unidad' : null,
        availability: _type == PostType.offer ? 'Horario flexible' : null,
      );
      widget.onCreated(post);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Nueva publicación',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: PostType.values
                  .map((t) => ChoiceChip(
                        label: Text(t.name),
                        selected: _type == t,
                        onSelected: (_) => setState(() => _type = t),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                  labelText: 'Título', border: OutlineInputBorder()),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentCtrl,
              decoration: const InputDecoration(
                  labelText: 'Contenido', border: OutlineInputBorder()),
              minLines: 4,
              maxLines: 6,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tagsCtrl,
              decoration: const InputDecoration(
                  labelText: 'Tags (separados por coma)',
                  border: OutlineInputBorder()),
            ),
            if (_type == PostType.request) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _budgetCtrl,
                decoration: const InputDecoration(
                    labelText: 'Presupuesto (USD)',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
            ],
            if (_type == PostType.offer) ...[
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                    child: TextField(
                  controller: _pricingFromCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Desde (precio)',
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                )),
                const SizedBox(width: 12),
                Expanded(
                    child: TextField(
                  controller: _pricingToCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Hasta (precio)',
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                )),
              ]),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.send),
                label: Text(_submitting ? 'Publicando...' : 'Publicar'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
