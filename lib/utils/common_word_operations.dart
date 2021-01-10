import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/pages/edit_word.dart';
import 'package:bocagoi/pages/show_word.dart';
import 'package:flutter/material.dart';

class CommonWordOperations {
  static void showWord(
    BuildContext context,
    Word word, {
    void Function(bool) callback,
  }) async {
    print("Navigating to word page: ");

    final res = await Navigator.of(context).push(MaterialPageRoute<bool>(
        builder: (ctx) => ShowWordPage(
              word: word,
            )));

    callback?.call(res);
  }

  static void editWord(
    BuildContext context,
    Word word, {
    Book book,
    void Function(bool) callback,
  }) async {
    print("Navigating to edit word page: ");

    final res = await Navigator.of(context).push(MaterialPageRoute<bool>(
        builder: (ctx) => EditWordPage(
              word: word,
              book: book,
            )));

    callback?.call(res);
  }

  static void addNewWord(
    BuildContext context, {
    Book book,
    void Function(bool) callback,
  }) async {
    editWord(
      context,
      Word(),
      book: book,
      callback: callback,
    );
  }
}
