import 'package:flutter/material.dart';

class NoteEditorPage extends StatelessWidget {
  const NoteEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Editor'),
      ),
      body: const Center(
        child: Text('Note Editor Page'),
      ),
    );
  }
}
