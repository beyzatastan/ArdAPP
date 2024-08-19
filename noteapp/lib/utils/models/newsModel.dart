class Newsmodel {
  String? author;
  String? title;
  String? description;
  String? url;
  String? publishedAt;

  Newsmodel({
    this.author,
    this.title,
    this.description,
    this.url,
    this.publishedAt,
  });

  // JSON'dan dönüşüm
  Newsmodel.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    publishedAt = json['publishedAt'];
  }

  // JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['publishedAt'] = this.publishedAt;
    return data;
  }
}
