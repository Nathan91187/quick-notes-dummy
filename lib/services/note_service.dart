import 'dart:convert';

import 'package:quick_notes/models/note.dart';
import 'package:http/http.dart';
class NoteService {
  String uri = "COMPUTER_IP:8080/notes";
  Future<void> deleteNote(String noteID) async{
    final response = await delete(
        Uri.parse("$uri/$noteID"));
    if(response.statusCode == 204){
      return;
    }
    else if (response.statusCode == 404) {
      throw Exception("Note not found");
    } else if (response.statusCode == 400) {
      throw Exception("Invalid request");
    } else if (response.statusCode >= 500) {
      throw Exception("Server error");
    } else {
      throw Exception("Unexpected error");
    }
  }
  Future<NoteModel> getNoteById(String noteID) async{
    final response = await get(
        Uri.parse("$uri/$noteID"));
    if (response.statusCode == 200) {
      return NoteModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception("Note not found");
    } else if (response.statusCode == 400) {
      throw Exception("Invalid request");
    } else if (response.statusCode >= 500) {
      throw Exception("Server error");
    } else {
      throw Exception("Unexpected error");
    }
  }
  Future<List<NoteModel>> getNotes() async{
    final response = await get(
        Uri.parse(uri)
    );
    if (response.statusCode == 200) {
      final List <dynamic >notes = jsonDecode(response.body);
      return notes.map((note)=> NoteModel.fromJson(note)).toList();
    } else if (response.statusCode == 404) {
      throw Exception("No notes found");
    } else if (response.statusCode == 400) {
      throw Exception("Invalid request");
    } else if (response.statusCode >= 500) {
      throw Exception("Server error");
    } else {
      throw Exception("Unexpected error");
    }
  }
  Future<NoteModel> createNote(NoteModel note) async{
      final response = await post(
          Uri.parse(uri),
          body: jsonEncode({
            ...note.toJson(),
          }
          ),
          headers: {
            'content-type' : 'application/json',
          }
      );
      if (response.statusCode == 201) {
        return NoteModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception("Note not found");
      } else if (response.statusCode == 400) {
        throw Exception("Invalid request");
      } else if (response.statusCode >= 500) {
        throw Exception("Server error");
      } else {
        throw Exception("Unexpected error");
      }
  }
  Future<NoteModel> editNote(String noteID, NoteModel note) async{

    final response = await put(
      Uri.parse("$uri/$noteID"),
      body: jsonEncode(note.toJson()),
      headers: {
        'content-type' : 'application/json'
      }
    );
    if (response.statusCode == 200) {
      return NoteModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception("Note not found");
    } else if (response.statusCode == 400) {
      throw Exception("Invalid request");
    } else if (response.statusCode >= 500) {
      throw Exception("Server error");
    } else {
      throw Exception("Unexpected error");
    }
  }
}