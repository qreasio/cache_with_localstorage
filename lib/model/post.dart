class PostItem {
  int id;
  String title;
  String body;
  bool fromCache = false;

  PostItem({this.id, this.title, this.body, this.fromCache});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'body': body};

  factory PostItem.fromJson(Map<String, dynamic> json) {
    return PostItem(id: json['id'], title: json['title'], body: json['body']);
  }
}
