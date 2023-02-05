import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessage extends StatelessWidget {
   ChatMessage(
      {super.key,
        required this.text,
        required this.sender,});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      margin: const BubbleEdges.only(top: 5, bottom: 5),
      alignment: sender == "user" ?Alignment.topRight : Alignment.topLeft,
      nip: sender == "user" ? BubbleNip.rightTop : BubbleNip.leftTop,
      nipWidth: 10,
    nipHeight: 10,
      color: sender == "user" ? Color.fromARGB(255, 53, 53, 53): Color(0xff1c1d20),
      
      child:  Text(text, style: GoogleFonts.poppins(color: Colors.white,fontSize: 15), textAlign: sender == "user" ? TextAlign.right : TextAlign.left),
    );
  }
}
