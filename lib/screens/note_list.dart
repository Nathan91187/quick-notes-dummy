import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_notes/common/loading.dart';
import 'package:quick_notes/providers/note_provider.dart';
import 'package:quick_notes/screens/edit_note_screen.dart';
import 'package:quick_notes/widgets/note_card.dart';
class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  String? errorMessage;
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      // wait for the widget to be constructed before getNotes calls notify listeners and
      // asks flutter ro rebuild our widget while its already being built,
      // hence the name postFrameCallback.
      try {
        await context.read<NoteProvider>().getNotes();
      } on Exception catch (e) {
       setState(() {
         errorMessage = e.toString();
       });
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your notes"),
      ),
      body: Consumer<NoteProvider>(
          builder: (context,noteProvider,child) {
            if(noteProvider.isLoading){
              return Loading();
            }
            else if(errorMessage != null){
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Color(0xFFF8FAFC).withValues(alpha: .2),
                      size: 30,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFF8FAFC).withValues(alpha: .2),
                      ),
                    ),
                  ],
                ),
              );
            }
            else if(noteProvider.noteList.isEmpty){
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Color(0xFFF8FAFC).withValues(alpha: .2),
                      size: 30,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "No notes to show",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFF8FAFC).withValues(alpha: .2),
                      ),
                    ),
                  ],
                ),
              );
            }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 5),
                child: ListView.builder(
                  itemCount: noteProvider.noteList.length,
                    itemBuilder: (context,index) => NoteCard(note: noteProvider.noteList[index])),
              );}
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (_)=> EditNoteScreen()));
        },
        child: Icon(
          Icons.add,
        )),
    );
  }
}
