import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/News/newsChatScreen.dart';
import 'package:noteapp/screens/login/optionScreen.dart';
import 'package:noteapp/utils/models/newsModel.dart';
import 'package:noteapp/utils/services/chats/chat_services.dart';
import 'package:noteapp/utils/services/news/api_services.dart';
import 'package:url_launcher/url_launcher.dart';

class Newsscreen extends StatefulWidget {
  const Newsscreen({super.key});

  @override
  State<Newsscreen> createState() => _NewsscreenState();
}

class _NewsscreenState extends State<Newsscreen> {
  final ApiServices newsapi = ApiServices();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Optionscreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        backgroundColor: HexColor(backgroundColor),
        title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "News",
              style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Newsmodel>>(
          future: newsapi.getNews(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.hasData) {
              final newsList = snapshot.data!;
              return ListView.builder(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  return Slidable(
                    key: Key(news.title ?? ""),
                    startActionPane:
                        ActionPane(motion: const DrawerMotion(), children: [
                      SlidableAction(
                        onPressed: (context) {
                          _displayBottomSheet(context, news);
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.share_sharp,
                      ),
                    ]),
                    child: ListTile(
                      title: Text(
                        news.title ?? "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "Inter",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          news.description ?? "",
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: HexColor(noteColor),
                          ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                      tileColor: HexColor(backgroundColor),
                      onTap: () {
  if (news.url != null && news.url!.isNotEmpty) {
    _launchURL(news.url!);
  } else {
    // URL geçersizse veya boşsa ne yapılacağına karar verin
    print("Invalid URL");
  }
},

                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("No news available."));
            }
          },
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _displayBottomSheet(BuildContext context, dynamic item) {
    return showModalBottomSheet(
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
              const SizedBox(height: 20),
              Text(
                "Share your note with:",
                style: TextStyle(
                  fontFamily: "Inter",
                  color: HexColor(noteColor),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              // Kullanıcıların Profil Resimleri ve İsimleri
              Container(
                height: 90,
                child: StreamBuilder(
                  stream: ChatServices().getUsersStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No users available."));
                    }

                    final users = snapshot.data!;

                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: users.map<Widget>((user) {
                        if (user["email"] != getCurrentUser()!.email) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Newschatscreen(
                                        newsUrl: item.url,
                                        receiverName: user["name"],
                                        receiverId: user["id"],
                                      )));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
  backgroundColor: Colors.black,
  backgroundImage: (user["picture"] != null && user["picture"].isNotEmpty)
      ? NetworkImage(user["picture"])
      : const AssetImage('assets/images/1024.png') as ImageProvider,
  radius: 30,
),

                                  const SizedBox(height: 8),
                                  Text(
                                    user["name"],
                                    style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
}
