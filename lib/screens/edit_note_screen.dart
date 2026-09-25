import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/common/loading.dart';
import 'package:quick_notes/common/text_field_decoration.dart';
import 'package:quick_notes/models/note.dart';
import 'package:quick_notes/providers/note_provider.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel? note;
  const EditNoteScreen({
    this.note,
    super.key});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final bodyController = TextEditingController();
  final titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
   String? errorMsg;
  bool isLoading = false;
  @override
  void initState(){
    super.initState();
    if(widget.note != null){

      bodyController.text = widget.note!.content;
      titleController.text = widget.note!.noteTitle;
    }
  }
  @override
  void dispose(){
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return  Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Add Note" : "Edit Note"),
      ),
      body: isLoading ? Loading() : SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Form(
                key: _formKey,
                  child: Column(
                    children: [

                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF8FAFC).withValues(alpha: 0.12),
                              ),
                              child: Icon(
                                Icons.title_outlined,
                                color: Color(0xFFF8FAFC),
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              "Title",
                              style: textTheme.bodyMedium!.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        maxLines: 1,
                        controller: titleController,
                        validator: (val) {
                          if(val == null || val.trim().isEmpty) {
                            return "Provide a title";
                          }
                          return null;
                        },
                        decoration: textFieldDecoration(context, hintText: "Enter title"),
                      ),
                      SizedBox(height: 12,),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFF8FAFC).withValues(alpha: 0.12)
                              ),
                              child: Icon(
                                Icons.notes_outlined,
                                color: Color(0xFFF8FAFC),
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              "Content",
                              style: textTheme.bodyMedium!.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: textFieldDecoration(context,hintText:  "Content"),
                        maxLines: 12,
                        minLines: 6,
                        controller: bodyController,
                        validator: (val) {
                          if(val == null || val.trim().isEmpty) {
                            return "Content can't be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10,),
                      if(errorMsg != null)
                      Text(
                        errorMsg!,
                        style: textTheme.bodyLarge!.copyWith(
                          color: colors.error
                        ),
                      ),
                      SizedBox(height: 28,),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: colors.primaryContainer,
                            foregroundColor: colors.onPrimaryContainer
                          ),
                            onPressed: () async{
                            if(_formKey.currentState!.validate()){
                              final title = titleController.text;
                              final body = bodyController.text;
                              setState(() {
                                errorMsg = null;
                                isLoading = true;
                              });
                              try {
                                if (widget.note == null) {
                                  await context.read<NoteProvider>().addNote(NoteModel(
                                      content: body,
                                      noteTitle: title));
                                }
                                else {
                                  await context.read<NoteProvider>().editNote(
                                      widget.note!.noteID!, NoteModel(
                                      content: body,
                                       noteTitle: title));
                                }
                                if(context.mounted){
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                              setState(() {
                                errorMsg = e.toString();
                              });
                              }
                              finally{
                                if (context.mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            }
                            },
                            label: Text(
                              widget.note == null ? "Create Note" : "Save Changes",
                            ),
                            icon: Icon(
                                widget.note == null ?
                                Icons.check_outlined
                                    : Icons.save_outlined,

                            )
                        ),
                      )
                    ],
                  )),
            ),
          )
      ),
    );
  }
}
