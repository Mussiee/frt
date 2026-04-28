class MockCheckedInGuest {
  final String id;
  final String name;
  final String checkInTime;
  final int tableNumber;
  final String section;
  final int partySize;
  final String reservationId;

  const MockCheckedInGuest({
    required this.id,
    required this.name,
    required this.checkInTime,
    required this.tableNumber,
    required this.section,
    required this.partySize,
    required this.reservationId,
  });
}

final List<MockCheckedInGuest> mockCheckedInGuests = [
  const MockCheckedInGuest(id: 'ci01', name: 'Julian Casablancas', checkInTime: '9:32 PM', tableNumber: 201, section: 'VIP LOUNGE', partySize: 4, reservationId: 'r001'),
  const MockCheckedInGuest(id: 'ci02', name: 'Marcus Thorne', checkInTime: '8:05 PM', tableNumber: 205, section: 'THE VAULT VIP', partySize: 8, reservationId: 'r003'),
  const MockCheckedInGuest(id: 'ci03', name: 'Alex Rivera', checkInTime: '9:10 PM', tableNumber: 304, section: 'THE TERRACE', partySize: 6, reservationId: 'r010'),
  const MockCheckedInGuest(id: 'ci04', name: 'Elena Rodriguez', checkInTime: '9:45 PM', tableNumber: 107, section: 'MAIN FLOOR', partySize: 5, reservationId: 'r004'),
  const MockCheckedInGuest(id: 'ci05', name: 'Valentino Russo', checkInTime: '7:30 PM', tableNumber: 202, section: 'THE VAULT VIP', partySize: 7, reservationId: 'r006'),
  const MockCheckedInGuest(id: 'ci06', name: 'David Hanes', checkInTime: '8:45 PM', tableNumber: 307, section: 'THE TERRACE', partySize: 3, reservationId: 'r009'),
  const MockCheckedInGuest(id: 'ci07', name: 'Soren Miller', checkInTime: '10:20 PM', tableNumber: 208, section: 'THE VAULT VIP', partySize: 4, reservationId: 'r007'),
  const MockCheckedInGuest(id: 'ci08', name: 'Jonathan Sterling', checkInTime: '10:55 PM', tableNumber: 110, section: 'MAIN FLOOR', partySize: 4, reservationId: 'r005'),
  const MockCheckedInGuest(id: 'ci09', name: 'Sarah Jenkins', checkInTime: '11:00 PM', tableNumber: 105, section: 'MAIN FLOOR', partySize: 6, reservationId: 'r002'),
  const MockCheckedInGuest(id: 'ci10', name: 'Sophia Laurent', checkInTime: '11:15 PM', tableNumber: 204, section: 'THE VAULT VIP', partySize: 4, reservationId: 'r008'),
];
