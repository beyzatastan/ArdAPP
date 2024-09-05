import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/utils/services/chats/chat_services.dart';
import 'package:noteapp/utils/services/chats/display_message.dart';
import 'package:url_launcher/url_launcher.dart';
class Newschatscreen extends StatefulWidget {
  
  final String receiverId;
  final String newsUrl;
  final String receiverName;
  const Newschatscreen({super.key,required this.receiverId,
  required this.receiverName,
  required this.newsUrl});

  @override
  State<Newschatscreen> createState() => _NotechatscreenState();
}

class _NotechatscreenState extends State<Newschatscreen> {
 final TextEditingController messageCont = TextEditingController();
  final ChatServices _chatServices = ChatServices();

 @override
  void initState() {
    super.initState();
    messageCont.text = "${widget.newsUrl}";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                widget.receiverName,
                style: const TextStyle(
                    fontFamily: "Inter", fontSize: 25, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: DisplayMessage(receivername: widget.receiverName,receiverId: widget.receiverId),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle,size: 26,color: HexColor(buttonBackground),),
                  onPressed: () => _displayBottomSheet(context),
                ),
                Expanded(
                    child: TextFormField(
                  controller: messageCont,
                  onSaved: (newValue) {
                    messageCont.text = newValue!;
                  },
                  style: const TextStyle(
                    fontFamily: "Inter",
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Message...",
                    enabled: true,
                    contentPadding: const EdgeInsets.only(left: 15, bottom: 8),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: HexColor(buttonBackground),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1,
                    
                      ),
                    ),
                  ),
                  validator: (value) {
                    return null;
                  },
                )),
                TextButton(
                    onPressed: sendMessage,
                    child: Text(
                      "Send",
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: HexColor(buttonBackground)),
                    ))
              ],
            ),
          ), 
          ],
        ),
      ),
    );
  }
  

  void sendMessage()async{
    if(messageCont.text.isNotEmpty){
      await _chatServices.sendMessage(widget.receiverId,messageCont.text,);
      messageCont.clear();
    }
  }


  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

    void _displayBottomSheet(BuildContext context,) {
    showModalBottomSheet(
      context: context,
      backgroundColor: HexColor(backgroundColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              
            ],
          ),
        );
      },
    );
  }
}