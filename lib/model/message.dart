class Message{
  String idFrom;
  String idTo;
  String content;
  String timestamp;

  Message({required this.idFrom, required this.idTo, required this.content, required this.timestamp});

  Map<String, dynamic> toJson() => {
    "idFrom": idFrom,
    "idTo": idTo,
    "content": content,
    "timestamp": timestamp,
  };
}