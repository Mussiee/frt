import 'package:equatable/equatable.dart';
import '../data/mock_promoters.dart';

abstract class PromotersState extends Equatable {
  const PromotersState();
  @override
  List<Object?> get props => [];
}

class PromotersInitial extends PromotersState {}

class PromotersLoadSuccess extends PromotersState {
  final List<MockPromoter> promoters;
  final List<MockPromoter> filtered;
  final String search;
  final int page;
  final int totalPages;

  const PromotersLoadSuccess({
    required this.promoters,
    required this.filtered,
    this.search = '',
    this.page = 1,
    this.totalPages = 1,
  });

  @override
  List<Object?> get props => [promoters, filtered, search, page, totalPages];
}
