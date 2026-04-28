class MockCustomer {
  final String id;
  final String name;
  final String phone;
  final String email;
  final int totalVisits;
  final double totalSpend;
  final String lastVisit;
  final String tier;
  final double tierProgress;
  final String nextTier;
  final List<MockVisitHistory> visitHistory;
  final List<MockPromoterLink> promoterLinks;

  const MockCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.totalVisits,
    required this.totalSpend,
    required this.lastVisit,
    required this.tier,
    required this.tierProgress,
    required this.nextTier,
    this.visitHistory = const [],
    this.promoterLinks = const [],
  });
}

class MockVisitHistory {
  final String date;
  final String status;
  final String promoter;
  final double payment;

  const MockVisitHistory({required this.date, required this.status, required this.promoter, required this.payment});
}

class MockPromoterLink {
  final String name;
  final String role;
  final int bookings;
  final String lastActivity;
  final bool hasPhoto;

  const MockPromoterLink({required this.name, required this.role, required this.bookings, required this.lastActivity, this.hasPhoto = false});
}

final List<MockCustomer> mockCustomers = [
  MockCustomer(
    id: 'c001', name: 'Alex Rivera', phone: '+1 555-012-3456', email: 'a.rivera@example.com',
    totalVisits: 12, totalSpend: 3450.00, lastVisit: 'Oct 24, 2023', tier: 'VIP GOLD',
    tierProgress: 0.85, nextTier: 'Diamond Member',
    visitHistory: const [
      MockVisitHistory(date: 'Oct 24, 2023', status: 'completed', promoter: 'Marcus V.', payment: 1200),
      MockVisitHistory(date: 'Sep 15, 2023', status: 'completed', promoter: 'Sarah L.', payment: 850),
      MockVisitHistory(date: 'Aug 28, 2023', status: 'no_show', promoter: 'Marcus V.', payment: 0),
      MockVisitHistory(date: 'Aug 10, 2023', status: 'completed', promoter: 'Direct', payment: 1400),
    ],
    promoterLinks: const [
      MockPromoterLink(name: 'Marcus Vance', role: 'Primary Contact', bookings: 7, lastActivity: 'Last 12 days ago', hasPhoto: true),
      MockPromoterLink(name: 'Sarah Lowery', role: 'Referral', bookings: 3, lastActivity: 'Last 40 days ago', hasPhoto: true),
      MockPromoterLink(name: 'Direct / No Promoter', role: '', bookings: 2, lastActivity: ''),
    ],
  ),
  const MockCustomer(id: 'c002', name: 'Julian Casablancas', phone: '+1 555-234-5678', email: 'julian@music.co', totalVisits: 24, totalSpend: 12800.00, lastVisit: 'Oct 27, 2023', tier: 'PLATINUM', tierProgress: 0.95, nextTier: 'Diamond Member'),
  const MockCustomer(id: 'c003', name: 'Sarah Jenkins', phone: '+1 555-889-9001', email: 'sarah.j@email.com', totalVisits: 8, totalSpend: 2200.00, lastVisit: 'Oct 20, 2023', tier: 'MEMBER', tierProgress: 0.45, nextTier: 'VIP Gold'),
  const MockCustomer(id: 'c004', name: 'Marcus Thorne', phone: '+1 555-234-8899', email: 'mthorne@corp.com', totalVisits: 18, totalSpend: 9500.00, lastVisit: 'Oct 26, 2023', tier: 'VIP GOLD', tierProgress: 0.70, nextTier: 'Platinum'),
  const MockCustomer(id: 'c005', name: 'Elena Rodriguez', phone: '+1 555-098-7712', email: 'elena@agency.co', totalVisits: 3, totalSpend: 450.00, lastVisit: 'Oct 18, 2023', tier: 'NEW', tierProgress: 0.10, nextTier: 'Member'),
  const MockCustomer(id: 'c006', name: 'Valentino Russo', phone: '+1 555-334-4556', email: 'val@nightlife.co', totalVisits: 32, totalSpend: 18900.00, lastVisit: 'Oct 27, 2023', tier: 'PLATINUM', tierProgress: 0.99, nextTier: 'Diamond Member'),
  const MockCustomer(id: 'c007', name: 'Kelly Lowman', phone: '+1 555-667-7889', email: 'kelly.l@email.com', totalVisits: 2, totalSpend: 0.00, lastVisit: 'Oct 23, 2023', tier: 'NEW', tierProgress: 0.05, nextTier: 'Member'),
  const MockCustomer(id: 'c008', name: 'David Hanes', phone: '+1 555-445-5667', email: 'dhanes@work.com', totalVisits: 6, totalSpend: 1800.00, lastVisit: 'Oct 22, 2023', tier: 'MEMBER', tierProgress: 0.35, nextTier: 'VIP Gold'),
];
