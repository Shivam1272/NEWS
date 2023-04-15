// ignore_for_file: avoid_print, unused_local_variable,, await_only_futures

import 'dart:convert';

import "package:http/http.dart" as http;

class News {
  List news = [];

  Future<List> getNews() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=2178702bb004400291173cd7ccd6447f";
    try {
      var response = await http.get(Uri.parse(url));
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == "ok") {
        jsonData["articles"].forEach((element) {
          if (element['urlToImage'] != null && element['description'] != null) {
            news.add(element);
          }
        });
      }
    } catch (e) {
      news = [];
    }
    return news;
  }
}

class NewsForCategorie {
  List news = [];

  Future<List> getNewsForCategory(String category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=2178702bb004400291173cd7ccd6447f";
    try {
      var response = await http.get(Uri.parse(url));
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == "ok") {
        jsonData["articles"].forEach((element) {
          if (element['urlToImage'] != null && element['description'] != null) {
            news.add(element);
          }
        });
      }
    } catch (e) {
      news = [];
    }
    return news;
  }
}
