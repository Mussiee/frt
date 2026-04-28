class MockPromoterSelfStats {
  static const String name = 'Julian Thorne';
  static const String badge = 'LEAD PROMOTER';
  static const String joinDate = 'Joined Oct 2023';
  static const String referralCode = 'JTHORNE2023';
  static const String referralLink = 'https://focus.club/r/JTHORNE2023';
  static const int totalBookings = 342;
  static const int paidBookings = 289;
  static const double revenue = 14240.00;
  static const double conversionRate = 84.5;
  static const String trendText = '+12% from last month';
  static const String revenueThisMonth = '\$2,455';
  static const int linkClicks = 1247;
  static const int conversionsThisWeek = 8;

  static const List<MockSelfReferral> recentReferrals = [
    MockSelfReferral(name: 'Julianne Davis', partyInfo: 'PARTY OF 6 · VIP TABLE', status: 'arrived', amount: 850.00, paymentLabel: 'FULLY PAID', date: 'Oct 24, 2023'),
    MockSelfReferral(name: 'Soren Miller', partyInfo: 'PARTY OF 12 · ULTRA VIP', status: 'confirmed', amount: 2400.00, paymentLabel: 'DEPOSIT ONLY', date: 'Oct 25, 2023'),
    MockSelfReferral(name: 'Kelly Lowman', partyInfo: 'PARTY OF 4 · STANDARD', status: 'no_show', amount: 0.00, paymentLabel: 'FORFEITED', date: 'Oct 23, 2023'),
  ];
}

class MockSelfReferral {
  final String name;
  final String partyInfo;
  final String status;
  final double amount;
  final String paymentLabel;
  final String date;

  const MockSelfReferral({
    required this.name,
    required this.partyInfo,
    required this.status,
    required this.amount,
    required this.paymentLabel,
    required this.date,
  });
}
