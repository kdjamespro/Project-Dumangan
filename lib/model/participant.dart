class Participant {
  Participant({
    this.id,
    required this.fullName,
    required this.email,
    required this.attended,
    this.organization = '',
    this.selected = false,
  });
  late int? id;
  late String fullName, email, organization;
  bool selected, attended;
}
