class Meme {
  Meme({
    required this.submissionId,
    required this.submissionUrl,
    required this.submissionTitle,
    required this.permalink,
    required this.author,
    required this.created,
    required this.timestamp,
  });

  String submissionId;
  String submissionUrl;
  String submissionTitle;
  String permalink;
  String author;
  DateTime created;
  DateTime timestamp;

  factory Meme.fromJson(Map<String, dynamic> json) => Meme(
        submissionId: json["submission_id"],
        submissionUrl: json["submission_url"],
        submissionTitle: json["submission_title"],
        permalink: json["permalink"],
        author: json["author"],
        created: DateTime.parse(json["created"]),
        timestamp: DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "submission_id": submissionId,
        "submission_url": submissionUrl,
        "submission_title": submissionTitle,
        "permalink": permalink,
        "author": author,
        "created": created.toIso8601String(),
        "timestamp": timestamp.toIso8601String(),
      };
}
