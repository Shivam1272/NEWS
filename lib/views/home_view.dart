// ignore_for_file: prefer_typing_uninitialized_variables, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
// import 'package:news_app/model/article_model.dart';
import 'package:news_app/model/category_model.dart';
import 'package:news_app/views/article_view.dart';
import 'package:news_app/views/category_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = <CategoryModel>[];
  List articles = [];
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNewsData();
  }

  getNewsData() async {
    News newsClass = News();
    articles = await newsClass.getNews();
    // articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "My",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "News",
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        actions: [
          Opacity(
            opacity: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.save),
            ),
          )
        ],
        centerTitle: true,
        elevation: 0.0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return CategoryTile(
                                imageurl: categories[index].imageUrl,
                                categoryname: categories[index].categoryName);
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(top: 16),
                          shrinkWrap: true,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return BlogTile(
                                imageUrl: articles[index]['urlToImage'],
                                title: articles[index]['title'],
                                desc: articles[index]['description'],
                                url: articles[index]['url']);
                          }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile(
      {Key? key, required this.imageurl, required this.categoryname})
      : super(key: key);
  final String imageurl, categoryname;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryView(
                      category: categoryname.toLowerCase(),
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imageurl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryname,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  const BlogTile(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.desc,
      required this.url})
      : super(key: key);
  final String imageUrl, title, desc, url;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(imageUrl: url)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(imageUrl)),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(desc, style: const TextStyle(color: Colors.black54))
          ],
        ),
      ),
    );
  }
}
