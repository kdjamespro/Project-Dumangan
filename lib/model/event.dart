class Event {
  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.participants,
    required this.absentees,
  });
  final int id;
  String name;
  String description;
  String date;
  int participants;
  int absentees;
}
