import 'dart:convert';

import 'package:cache_with_localstorage/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

class PostService {
  String baseURL = 'https://jsonplaceholder.typicode.com';
  static LocalStorage storage = new LocalStorage('post');
  var stopwatch = new Stopwatch()..start();

  Future<PostItem> getPost() async {
    var post = await getPostFromCache();
    if (post == null) {
      return getPostFromAPI();
    }
    return post;
  }

  Future<PostItem> getPostFromAPI() async {
    PostItem post = await fetchPost();
    post.fromCache = false; //to indicate post is pulled from API
    savePost(post);
    return post;
  }

  Future<PostItem> getPostFromCache() async {
    await storage.ready;
    Map<String, dynamic> data = storage.getItem('post');
    if (data == null) {
      return null;
    }
    PostItem post = PostItem.fromJson(data);
    post.fromCache = true; //to indicate post is pulled from cache
    return post;
  }

  void savePost(PostItem post) async {
    await storage.ready;
    storage.setItem("post", post);
  }

  Future<PostItem> fetchPost() async {
    String _endpoint = '/posts/1';

    dynamic post = await _get(_endpoint);
    if (post == null) {
      return null;
    }
    PostItem p = new PostItem.fromJson(post);
    return p;
  }

  Future _get(String url) async {
    String endpoint = '$baseURL$url';
    try {
      final response = await http.get(endpoint);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (err) {
      throw Exception(err);
    }
  }
}
