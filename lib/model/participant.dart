class Participant {
  Participant({
    this.id,
    required this.fullName,
    required this.email,
    this.organization = '',
    this.selected = false,
  });
  late int? id;
  late String fullName, email, organization;
  bool selected;
}

List<Participant> participantList = [
  Participant(id: 0, fullName: 'Jane', email: 'JaneDoe@gmail.com'),
  Participant(id: 1, fullName: 'John', email: 'JohnDoe@gmail.com'),
  Participant(id: 2, fullName: 'Will', email: 'WillSmith@gmail.com'),
  Participant(id: 3, fullName: 'Eddy', email: 'EddyMaricruz@gmail.com'),
  Participant(id: 4, fullName: 'Steve', email: 'SteveRogers@gmail.com'),
  Participant(id: 5, fullName: 'Bruce', email: 'BruceBanner@gmail.com'),
  Participant(id: 6, fullName: 'Tony', email: 'TonyStark@gmail.com'),
];
