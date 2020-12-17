import 'package:bocagoi/models/book.dart';
import 'package:bocagoi/models/word.dart';
import 'package:bocagoi/pages/edit_word.dart';
import 'package:bocagoi/pages/show_word.dart';
import 'package:flutter/material.dart';

class CommonWordOperations {

  static void showWord(
      BuildContext context,
      Word word, {
        VoidCallback callback,
      }) async {
    print("Navigating to edit word page: ");

    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (ctx) => ShowWordPage(
          word: word,
        )));

    callback?.call();
  }


  static void editWord(
    BuildContext context,
    Word word, {
    Book book,
    VoidCallback callback,
  }) async {
    print("Navigating to edit word page: ");

    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (ctx) => EditWordPage(
              word: word,
              book: book,
            )));

    callback?.call();
  }

  static void addNewWord(
    BuildContext context, {
    Book book,
    VoidCallback callback,
  }) async {
    editWord(
      context,
      Word(),
      book: book,
      callback: callback,
    );
  }
}
