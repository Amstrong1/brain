class Note {
  int? id; // Make id nullable to handle potential null values
  String date;
  String title;

  Note({
    this.id,
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
}