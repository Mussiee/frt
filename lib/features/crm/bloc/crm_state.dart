import 'package:equatable/equatable.dart';
import '../data/mock_customers.dart';

abstract class CrmState extends Equatable {
  const CrmState();
  @override
  List<Object?> get props => [];
}

class CrmInitial extends CrmState {}

class CrmLoadSuccess extends CrmState {
  final List<MockCustomer> customers;
  final List<MockCustomer> filtered;
  final String filter;
  final String search;

  const CrmLoadSuccess({
    required this.customers,
    required this.filtered,
    this.filter = 'ALL',
    this.search = '',
  });

  @override
  List<Object?> get props => [customers, filtered, filter, search];
}
