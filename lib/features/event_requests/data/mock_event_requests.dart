class MockEventRequest {
  final String id;
  final String name;
  final String subtitle;
  final String phone;
  final String email;
  final String requestedDate;
  final String time;
  final String section;
  final String status;
  final int expectedGuests;
  final String? eventType;
  final double? budget;
  final String? notes;
  final String? company;

  const MockEventRequest({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.phone,
    required this.email,
    required this.requestedDate,
    required this.time,
    required this.section,
    required this.status,
    required this.expectedGuests,
    this.eventType,
    this.budget,
    this.notes,
    this.company,
  });
}

final List<MockEventRequest> mockEventRequests = [
  const MockEventRequest(id: 'e001', name: 'Jonathan Sterling', subtitle: 'Platinum Member', phone: '+1 (555) 012-4432', email: 'j.sterling@corp.com', requestedDate: 'Oct 24, 2023', time: '11:30 PM', section: 'MAIN FLOOR VIP', status: 'reviewing', expectedGuests: 25, eventType: 'Corporate Launch', budget: 15000.00, company: 'Sterling Corp'),
  const MockEventRequest(id: 'e002', name: 'Elena Rodriguez', subtitle: 'New Client', phone: '+1 (555) 098-7712', email: 'elena.r@agency.co', requestedDate: 'Oct 25, 2023', time: '10:00 PM', section: 'THE TERRACE', status: 'incoming', expectedGuests: 40, eventType: 'Birthday Party', budget: 8000.00),
  const MockEventRequest(id: 'e003', name: 'Marcus Thorne', subtitle: 'Lead', phone: '+1 (555) 234-8899', email: 'thorne.m@night.life', requestedDate: 'Oct 24, 2023', time: '12:00 AM', section: 'THE VAULT VIP', status: 'priority', expectedGuests: 15, eventType: 'Private Dinner', budget: 25000.00, notes: 'Requires full VIP buyout, private security'),
  const MockEventRequest(id: 'e004', name: 'Adrian Miller', subtitle: 'Inquiry', phone: '+1 (555) 445-1122', email: 'miller.a@gmail.com', requestedDate: 'Oct 26, 2023', time: '11:00 PM', section: 'SKY LOUNGE', status: 'pending', expectedGuests: 50, eventType: 'New Year Eve', budget: 30000.00),
  const MockEventRequest(id: 'e005', name: 'Sophia Laurent', subtitle: 'VIP Member', phone: '+1 (555) 331-9988', email: 'sophia@laurent.com', requestedDate: 'Oct 30, 2023', time: '9:00 PM', section: 'VIP LOUNGE', status: 'reviewing', expectedGuests: 12, eventType: 'Anniversary', budget: 5000.00),
  const MockEventRequest(id: 'e006', name: 'David Kim', subtitle: 'Corporate', phone: '+1 (555) 776-5544', email: 'd.kim@techco.io', requestedDate: 'Nov 2, 2023', time: '8:00 PM', section: 'MAIN FLOOR VIP', status: 'incoming', expectedGuests: 80, eventType: 'Product Launch', budget: 45000.00, company: 'TechCo', notes: 'Full venue buyout requested'),
  const MockEventRequest(id: 'e007', name: 'Isabella Vance', subtitle: 'Returning Client', phone: '+1 (555) 223-4455', email: 'bella@vance.co', requestedDate: 'Oct 29, 2023', time: '10:30 PM', section: 'THE TERRACE', status: 'pending', expectedGuests: 20, eventType: 'Birthday', budget: 6000.00),
  const MockEventRequest(id: 'e008', name: 'James Wright', subtitle: 'New Inquiry', phone: '+1 (555) 889-0011', email: 'jwright@email.com', requestedDate: 'Nov 5, 2023', time: '11:00 PM', section: 'THE VAULT VIP', status: 'pending', expectedGuests: 30, eventType: 'Private Event', budget: 20000.00),
];
