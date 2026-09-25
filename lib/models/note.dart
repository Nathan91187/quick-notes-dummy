

class NoteModel {
  String? noteID;
  String noteTitle;
  String content;
  NoteModel({
    required this.content,
     this.noteID,
  required this.noteTitle,
});
  factory NoteModel.fromJson(Map<String, dynamic> json){
    return NoteModel(
        content: json['content'],
        noteID: json['id'].toString(),
        noteTitle: json['title']);
  }
  Map<String, dynamic> toJson (){
    return {
      'title' : noteTitle,
      'content' : content
    };
  }
}