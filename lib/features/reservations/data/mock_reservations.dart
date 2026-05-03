class MockReservation {
  final String id;
  final String customerName;
  final String phone;
  final String section;
  final String status;
  final String paymentStatus;
  final String date;
  final String time;
  final int partySize;
  final String? promoterName;
  final String? tableNumber;
  final String? notes;
  final double? amount;
  final String? tier;
  final String source;
  final String? sourceChannel;

  const MockReservation({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.section,
    required this.status,
    required this.paymentStatus,
    required this.date,
    required this.time,
    required this.partySize,
    this.promoterName,
    this.tableNumber,
    this.notes,
    this.amount,
    this.tier,
    this.source = 'direct',
    this.sourceChannel,
  });
}

final List<MockReservation> mockReservations = [
  const MockReservation(id: 'r001', customerName: 'Julian Casablancas', phone: '+1 (555) 012-3456', section: 'VIP LOUNGE', status: 'confirmed', paymentStatus: 'paid', date: 'Oct 27, 2023', time: '9:30 PM', partySize: 4, promoterName: 'Marc Russo', tableNumber: '201', amount: 2400.00, tier: 'VIP GOLD', source: 'promoter', sourceChannel: 'instagram'),
  const MockReservation(id: 'r002', customerName: 'Sarah Jenkins', phone: '+1 (555) 889-9001', section: 'MAIN FLOOR', status: 'pending', paymentStatus: 'deposit', date: 'Oct 28, 2023', time: '10:00 PM', partySize: 6, amount: 1200.00, tier: 'PLATINUM'),
  const MockReservation(id: 'r003', customerName: 'Marcus Thorne', phone: '+1 (555) 234-8899', section: 'THE VAULT VIP', status: 'checked_in', paymentStatus: 'paid', date: 'Oct 27, 2023', time: '8:00 PM', partySize: 8, promoterName: 'Sarah Jenkins', tableNumber: '205', amount: 5400.00, tier: 'VIP GOLD', source: 'promoter'),
  const MockReservation(id: 'r004', customerName: 'Elena Rodriguez', phone: '+1 (555) 098-7712', section: 'THE TERRACE', status: 'confirmed', paymentStatus: 'paid', date: 'Oct 28, 2023', time: '9:00 PM', partySize: 4, amount: 850.00),
  const MockReservation(id: 'r005', customerName: 'Adrian Miller', phone: '+1 (555) 445-1122', section: 'SKY LOUNGE', status: 'pending', paymentStatus: 'unpaid', date: 'Oct 29, 2023', time: '11:00 PM', partySize: 10, notes: 'Birthday celebration, needs cake'),
  const MockReservation(id: 'r006', customerName: 'Julianne Davis', phone: '+1 (555) 990-0123', section: 'THE TERRACE', status: 'completed', paymentStatus: 'paid', date: 'Oct 24, 2023', time: '8:30 PM', partySize: 5, promoterName: 'Marc Russo', tableNumber: '303', amount: 850.00, source: 'promoter', sourceChannel: 'facebook'),
  const MockReservation(id: 'r007', customerName: 'Soren Miller', phone: '+1 (555) 223-3445', section: 'THE VAULT VIP', status: 'confirmed', paymentStatus: 'deposit', date: 'Oct 28, 2023', time: '10:30 PM', partySize: 4, tableNumber: '208', amount: 2400.00),
  const MockReservation(id: 'r008', customerName: 'Kelly Lowman', phone: '+1 (555) 667-7889', section: 'MAIN FLOOR', status: 'no_show', paymentStatus: 'unpaid', date: 'Oct 23, 2023', time: '9:00 PM', partySize: 3),
  const MockReservation(id: 'r009', customerName: 'David Hanes', phone: '+1 (555) 445-5667', section: 'THE TERRACE', status: 'completed', paymentStatus: 'paid', date: 'Oct 22, 2023', time: '8:00 PM', partySize: 4, promoterName: 'Elena Meyer', tableNumber: '307', amount: 420.00, source: 'promoter'),
  const MockReservation(id: 'r010', customerName: 'Alex Rivera', phone: '+1 (555) 012-3456', section: 'VIP LOUNGE', status: 'checked_in', paymentStatus: 'paid', date: 'Oct 27, 2023', time: '9:00 PM', partySize: 6, tableNumber: '304', amount: 950.00, tier: 'VIP GOLD'),
  // Guestlist entries
  const MockReservation(id: 'r011', customerName: 'Natasha Petrova', phone: '+1 (555) 111-2233', section: 'MAIN FLOOR', status: 'confirmed', paymentStatus: 'free', date: 'Oct 28, 2023', time: '9:00 PM', partySize: 2, source: 'guestlist', notes: 'Plus one confirmed'),
  const MockReservation(id: 'r012', customerName: 'Jake Morrison', phone: '+1 (555) 333-4455', section: 'MAIN FLOOR', status: 'pending', paymentStatus: 'free', date: 'Oct 28, 2023', time: '10:00 PM', partySize: 3, source: 'guestlist', promoterName: 'Marc Russo'),
  const MockReservation(id: 'r013', customerName: 'Isabella Chen', phone: '+1 (555) 555-6677', section: 'VIP LOUNGE', status: 'checked_in', paymentStatus: 'free', date: 'Oct 27, 2023', time: '9:30 PM', partySize: 4, source: 'guestlist', tableNumber: '301'),
  const MockReservation(id: 'r014', customerName: 'Ryan O\'Sullivan', phone: '+1 (555) 777-8899', section: 'MAIN FLOOR', status: 'confirmed', paymentStatus: 'free', date: 'Oct 28, 2023', time: '9:00 PM', partySize: 1, source: 'guestlist'),
];
