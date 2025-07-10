import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noteapp/utils/models/newsModel.dart';

class ApiServices {
  Future<List<Newsmodel>> getNews() async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?country=tr&apiKey=55bf61b34f6d4fb182bfdaf93a819d73'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = jsonDecode(response.body);
      final List<dynamic> responseList = responseMap['articles'];

      return responseList.map((json) => Newsmodel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
