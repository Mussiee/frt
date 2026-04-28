class MockNotification {
  final String id;
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final String type;

  const MockNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.type,
  });
}

final List<MockNotification> mockNotifications = [
  const MockNotification(id: 'n01', title: 'New Reservation', body: 'Julian Casablancas booked VIP Lounge for Oct 27', time: '2 min ago', isRead: false, type: 'reservation'),
  const MockNotification(id: 'n02', title: 'Payment Received', body: '\$2,400.00 from Soren Miller — Deposit confirmed', time: '15 min ago', isRead: false, type: 'payment'),
  const MockNotification(id: 'n03', title: 'Event Request', body: 'Jonathan Sterling submitted a corporate event request', time: '32 min ago', isRead: false, type: 'event'),
  const MockNotification(id: 'n04', title: 'Check-In Alert', body: 'Marcus Thorne checked in at Table 205', time: '1 hour ago', isRead: true, type: 'checkin'),
  const MockNotification(id: 'n05', title: 'Table Freed', body: 'Table 307 marked as free by Elena R.', time: '1 hour ago', isRead: true, type: 'table'),
  const MockNotification(id: 'n06', title: 'No Show', body: 'Kelly Lowman marked as no-show for Oct 23 reservation', time: '3 hours ago', isRead: true, type: 'reservation'),
  const MockNotification(id: 'n07', title: 'New Promoter Referral', body: 'Marc Russo referred a new VIP client', time: '5 hours ago', isRead: true, type: 'promoter'),
  const MockNotification(id: 'n08', title: 'System Update', body: 'Floor layout updated for The Vault VIP section', time: 'Yesterday', isRead: true, type: 'system'),
];
