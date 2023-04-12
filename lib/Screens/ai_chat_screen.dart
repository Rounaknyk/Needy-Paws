import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:needy_paw/MyWidgets/chat_bubble2.dart';
import 'package:http/http.dart' as http;
import 'package:needy_paw/constants.dart';
import 'dart:convert';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import '../MyWidgets/chat_bubble.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({Key? key}) : super(key: key);

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {

  List<ChatBubble2> messages = [];
  TextEditingController _controller = TextEditingController();
  ChatCTResponse? chatGPT;
  bool chatLoading = false;
  bool screenLoading = true;
  ScrollController _scrollController = ScrollController();

  Future sendMsg() async {
    messages.add(ChatBubble2(text: _controller.text, isMe: true));
    String prompt = _controller.text;
    setState(() {
      _controller.clear();
    });
    String res = await generateResponse(prompt);
    messages.add(ChatBubble2(text: res.trim(), isMe: false));
  }
  

  Future<String> generateResponse(String prompt) async {
    setState(() {
      chatLoading = true;
    });
    try {
      Map < String, dynamic > requestBody = {
        "model": "text-davinci-003",
        "prompt": prompt,
        "temperature": 0,
        "max_tokens": 100,
      };
      // Post Api Url
      var url = Uri.parse('https://api.openai.com/v1/completions');
      //  use post method of http and pass url,headers and body according to documents
      var response = await http.post(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $chatAiKey"
      }, body: json.encode(requestBody)); // post call
      // Checked we get the response or not
      // if status code is 200 then Api Call is Successfully Executed
      if (response.statusCode == 200) {
        setState(() {
          chatLoading = false;
        });
        var responseJson = json.decode(response.body);
        print(responseJson);
        return responseJson["choices"][0]["text"];
      } else {
        setState(() {
          chatLoading = false;
        });
        return "Failed to generate text: ${response.body}";
      }
    } catch (e) {
      setState(() {
        chatLoading = false;
      });
      setState(() {
        chatLoading = false;
      });
      return "Failed to generate text: $e";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_scrollController.positions.isNotEmpty) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
    getInitialResponse();

  }

  getInitialResponse() async {
    screenLoading = true;
    await generateResponse('Hello, I am naming your max this time. So your name is max');
    screenLoading = false;
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with Max'),),
      body: screenLoading ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset('Animations/robot.json', width: MediaQuery.of(context).size.width * 0.5, height: MediaQuery.of(context).size.height * 0.5),
            SizedBox(height: 10,),
            Text('Just a moment while I get things ready for you...'),
          ],
        ),
      ) : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(itemBuilder: (context, index){

                  return messages[index];
                }, itemCount: messages.length, controller: _scrollController),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: chatLoading ? Row(
                  children: [
                    LottieBuilder.asset('Animations/robot.json', height: MediaQuery.of(context).size.height * 0.1,),
                    SizedBox(width: 20,),
                    Expanded(child: Text('Fluffy is getting your answer ready...'))
                  ],
                 ) : Row(
                  children: [
                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(maxHeight: 200, minHeight: 64),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white,),
                        child: TextField(
                          maxLines: null,
                          controller: _controller,
                          decoration: InputDecoration(hintText: 'Ask Max', contentPadding: EdgeInsets.all(16), border: InputBorder.none,),
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        _scrollController.animateTo(_scrollController.position
                            .maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                        sendMsg();
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.send, color: Colors.white,),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
