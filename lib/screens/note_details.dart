import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/providers/note_provider.dart';
import 'package:quick_notes/screens/edit_note_screen.dart';

class NoteDetails extends StatelessWidget {
  final String noteId;
  const NoteDetails({
    super.key,
    required this.noteId
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: ( context, noteProvider,child)
      { final note = noteProvider.noteList.firstWhere((note)=> note.noteID == noteId);
        return Scaffold(
        appBar: AppBar(
          title: Text(note.noteTitle),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withValues(alpha: 50),
                      borderRadius: BorderRadius.circular(15),

                    ),
                    child: Text(
                      note.content,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge,
                    ),
                  ),
                ),
                SizedBox(height: 28,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme
                            .of(context)
                            .colorScheme
                            .primaryContainer,
                        foregroundColor: Theme
                            .of(context)
                            .colorScheme
                            .onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => EditNoteScreen(note: note)));
                    },
                    icon: const Icon(Icons.edit),
                    label: Text(
                      'Edit Note',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onPrimaryContainer,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );}
    );
  }
}
