import 'package:cache_with_localstorage/widget/notifier.dart';
import 'package:flutter/material.dart';
import 'package:cache_with_localstorage/model/post.dart';
import 'package:cache_with_localstorage/service/post.dart';

class SecondPage extends StatefulWidget {
  SecondPage({this.title});

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final String title;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  PostItem post;
  PostService service = PostService();
  Exception e;

  void _loadPost() async {
    try {
      PostItem thePost = await service.getPost();
      setState(() {
        post = thePost;
      });
    } catch (err) {
      setState(() {
        e = err;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  @override
  Widget build(BuildContext context) {
    if (e != null) {
      Future.delayed(
          Duration.zero,
          () => showAlert(
              context, e.toString(), widget._scaffoldKey.currentState));
    }

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.title),
      ),
      body: Center(
          child: post == null
              ? CircularProgressIndicator()
              : Padding(
                  padding: EdgeInsets.all(100),
                  child: Column(children: <Widget>[
                    Text(post.title),
                    SizedBox(height: 20),
                    Text('From CACHE: ${post.fromCache}')
                  ]))),
    );
  }
}
