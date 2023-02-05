import 'dart:async';
import 'package:chatgpt_demo/app/data/app_constants.dart';
import 'package:chatgpt_demo/app/models/answer_model.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/chat_message.dart';

class HomeController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  StreamSubscription? subscription;
  RxBool isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    subscription?.cancel();
    super.onClose();
  }

  void sendMessage() {
    if (textController.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: textController.text,
      sender: "user",
    );
    messages.insert(0, message);
    isTyping.value = true;
    apiCall(msg: textController.text.trim());
    textController.clear();
  }

  void insertNewData(String response) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "bot",
    );
    print(response);

    messages.insert(0, botMessage);
    isTyping.value = false;
    //     for (int i=0;i==botMessage.toString().split(' ').length;i+200) {
    //   if (botMessage.toString().split(' ').length >= 200) {
    //   }
    // }
  }

  Widget buildChatTextEditor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              onSubmitted: (value) => sendMessage(),
              cursorColor: Colors.grey,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  color: Colors.white),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                filled: true, //<-- SEE HERE
                fillColor: const Color(0xff1c1d20),
                hintText: 'Ara..',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.transparent, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.all(15),
                labelStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: Colors.white),
                hintStyle: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            child: IconButton(
              icon: const Icon(
                IconlyBold.send,
                color: Colors.white,
              ),
              onPressed: () {
                sendMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Dio dio = Dio();
  void apiCall({required String msg}) async {
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["authorization"] = "Bearer ${AppConstants.apiKey}";

    Map<String, dynamic> data = {
      "model": "text-davinci-003",
      "prompt": msg,
      "temperature": 0,
      "max_tokens": 1000
    };

    var response =
        await dio.post("https://api.openai.com/v1/completions", data: data);
    AnswerModel answerModel = AnswerModel.fromJson(response.data);
    insertNewData(answerModel.choices?.first.text?.trim() ?? "");
  }
}
