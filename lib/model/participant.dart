class Participant {
  Participant(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.organization = ''});
  late int id;
  late String firstName, lastName, email, organization;
}

List<Participant> participantList = [
  Participant(
      id: 0, firstName: 'Jane', lastName: 'Doe', email: 'JaneDoe@gmail.com'),
  Participant(
      id: 1, firstName: 'John', lastName: 'Doe', email: 'JohnDoe@gmail.com'),
  Participant(
      id: 2,
      firstName: 'Will',
      lastName: 'Smith',
      email: 'WillSmith@gmail.com'),
  Participant(
      id: 3,
      firstName: 'Eddy',
      lastName: 'Maricruz',
      email: 'EddyMaricruz@gmail.com'),
  Participant(
      id: 4,
      firstName: 'Steve',
      lastName: 'Rogers',
      email: 'SteveRogers@gmail.com'),
  Participant(
      id: 5,
      firstName: 'Bruce',
      lastName: 'Banner',
      email: 'BruceBanner@gmail.com'),
  Participant(
      id: 6,
      firstName: 'Tony',
      lastName: 'Stark',
      email: 'TonyStark@gmail.com'),
];
