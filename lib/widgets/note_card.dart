import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/models/note.dart';
import 'package:quick_notes/providers/note_provider.dart';
import 'package:quick_notes/screens/edit_note_screen.dart';
import 'package:quick_notes/screens/note_details.dart';

class NoteCard extends StatefulWidget {
  final NoteModel note;

  const NoteCard({super.key, required this.note});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) => NoteDetails(noteId: widget.note.noteID!)));

      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.note.noteTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyLarge,
                    ),
                  ),
                  Consumer<NoteProvider>(
                    builder: (context, noteProvider,child)
                    {
                      final isDeleting = noteProvider.deletingNoteId == widget.note.noteID;
                      return isDeleting? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFF8FAFC),
                        ),
                      ): PopupMenuButton<String>(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      color: colors.primaryContainer,
                      onSelected: (value) async {
                        if (value == "edit_note") {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (_) =>
                                  EditNoteScreen(note: widget.note,)));
                        } else if (value == "delete_note") {
                          try {
                            await context.read<NoteProvider>().deleteNote(
                                widget.note.noteID!);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      "Note deleted successfully"))
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(e.toString()))
                              );
                            }
                          }
                        }
                      },
                      itemBuilder: (context) =>
                      [
                        PopupMenuItem(
                          value: 'edit_note',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                color: colors.onPrimaryContainer,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Edit Note',
                                style: textTheme.bodyLarge?.copyWith(
                                    fontSize: 15,
                                    color: colors.onPrimaryContainer,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuDivider(
                          height: 2,
                          color: colors.onPrimaryContainer,
                          indent: 5,
                          endIndent: 5,
                        ),
                        PopupMenuItem(
                          value: 'delete_note',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outlined, color: colors.error),
                              const SizedBox(width: 5),
                              Text(
                                'Delete Note',
                                style: textTheme.bodyLarge?.copyWith(
                                    color: colors.error,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );}
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.onPrimaryContainer.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  widget.note.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 6),

              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Text(
              //     "${note.createdAt.year}/"
              //     "${note.createdAt.month}/"
              //     "${note.createdAt.day}",
              //     style: textTheme.bodySmall,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
