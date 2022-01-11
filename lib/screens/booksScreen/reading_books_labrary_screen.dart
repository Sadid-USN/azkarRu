import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class ReadingBooksOnline extends StatefulWidget {
  final File? file;

  const ReadingBooksOnline({
    Key? key,
    this.file,
  }) : super(key: key);

  @override
  State<ReadingBooksOnline> createState() => _ReadingBooksOnlineState();
}

class _ReadingBooksOnlineState extends State<ReadingBooksOnline> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file!.path);
    return Scaffold(
      
      appBar: AppBar(title:  Text(name),),
      body: PDFView(
        filePath: widget.file!.path ,
        
      ),
    );
  }
}
