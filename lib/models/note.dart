class Note {
  int id;
  String date;
  String title;

  Note({
    required this.id,
    required this.date,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': date,
      'email': title,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      date: json['date'],
      title: json['title'],
    );
  }
}
