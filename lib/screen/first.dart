import 'package:cache_with_localstorage/screen/second.dart';
import 'package:cache_with_localstorage/widget/notifier.dart';
import 'package:flutter/material.dart';
import 'package:cache_with_localstorage/model/post.dart';
import 'package:cache_with_localstorage/service/post.dart';

class FirstPage extends StatefulWidget {
  FirstPage({this.title});

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final String title;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
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

    Widget getFirstPage(){
      return Padding(
          padding: EdgeInsets.all(100),
          child: Column(children: <Widget>[
            Text(post.title),
            SizedBox(height: 20),
            Text('From CACHE: ${post.fromCache}'),
            SizedBox(height: 20),
            FlatButton(
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SecondPage(title: "Load from cache")),
                ),
                child: Text('Next Page'))
          ]));
    }

    return Scaffold(
        key: widget._scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: post == null
                ? showIndicator(e)
                : getFirstPage()));
  }
}
