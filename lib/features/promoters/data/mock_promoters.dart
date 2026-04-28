class MockPromoter {
  final String id;
  final String name;
  final String initials;
  final String referralLink;
  final int totalBookings;
  final int paidBookings;
  final double revenue;
  final String status;
  final String joinDate;
  final String badge;
  final double conversionRate;
  final String revenueThisPeriod;
  final String trendText;
  final List<MockPromoterBooking> recentBookings;

  const MockPromoter({
    required this.id,
    required this.name,
    required this.initials,
    required this.referralLink,
    required this.totalBookings,
    required this.paidBookings,
    required this.revenue,
    required this.status,
    required this.joinDate,
    required this.badge,
    required this.conversionRate,
    required this.revenueThisPeriod,
    required this.trendText,
    this.recentBookings = const [],
  });
}

class MockPromoterBooking {
  final String customerName;
  final String partyInfo;
  final String status;
  final double amount;
  final String paymentLabel;
  final String date;

  const MockPromoterBooking({
    required this.customerName,
    required this.partyInfo,
    required this.status,
    required this.amount,
    required this.paymentLabel,
    required this.date,
  });
}

final List<MockPromoter> mockPromoters = [
  MockPromoter(
    id: 'p001', name: 'Valentino Russo', initials: 'VR',
    referralLink: 'focus.club/vip/russo...', totalBookings: 482, paidBookings: 412,
    revenue: 64250.00, status: 'active', joinDate: 'Joined Sep 2022', badge: 'TOP PERFORMER',
    conversionRate: 85.5, revenueThisPeriod: '\$8,420', trendText: '+18% from last month',
    recentBookings: [
      MockPromoterBooking(customerName: 'Julianne Davis', partyInfo: 'PARTY OF 6 · VIP TABLE', status: 'arrived', amount: 850.00, paymentLabel: 'FULLY PAID', date: 'Oct 24, 2023'),
      MockPromoterBooking(customerName: 'Soren Miller', partyInfo: 'PARTY OF 12 · ULTRA VIP', status: 'confirmed', amount: 2400.00, paymentLabel: 'DEPOSIT ONLY', date: 'Oct 25, 2023'),
      MockPromoterBooking(customerName: 'Kelly Lowman', partyInfo: 'PARTY OF 4 · STANDARD', status: 'no_show', amount: 0.00, paymentLabel: 'FORFEITED', date: 'Oct 23, 2023'),
    ],
  ),
  const MockPromoter(id: 'p002', name: 'Sarah Jenkins', initials: 'SK', referralLink: 'focus.club/vip/sarah...', totalBookings: 315, paidBookings: 298, revenue: 42110.00, status: 'active', joinDate: 'Joined Jan 2023', badge: 'LEAD PROMOTER', conversionRate: 94.6, revenueThisPeriod: '\$5,200', trendText: '+12% from last month'),
  const MockPromoter(id: 'p003', name: 'Marcus Jordan', initials: 'MJ', referralLink: 'focus.club/vip/jordan...', totalBookings: 256, paidBookings: 210, revenue: 38400.00, status: 'active', joinDate: 'Joined Mar 2023', badge: 'PROMOTER', conversionRate: 82.0, revenueThisPeriod: '\$3,800', trendText: '+8% from last month'),
  const MockPromoter(id: 'p004', name: 'Elena Meyer', initials: 'EM', referralLink: 'focus.club/vip/meyer...', totalBookings: 189, paidBookings: 155, revenue: 29780.00, status: 'active', joinDate: 'Joined May 2023', badge: 'PROMOTER', conversionRate: 82.0, revenueThisPeriod: '\$2,900', trendText: '+5% from last month'),
  const MockPromoter(id: 'p005', name: 'David Hanes', initials: 'DH', referralLink: 'focus.club/vip/hanes...', totalBookings: 112, paidBookings: 98, revenue: 15420.00, status: 'active', joinDate: 'Joined Jul 2023', badge: 'PROMOTER', conversionRate: 87.5, revenueThisPeriod: '\$1,200', trendText: '+3% from last month'),
];
