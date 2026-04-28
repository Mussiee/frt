import 'package:equatable/equatable.dart';

abstract class PromotersEvent extends Equatable {
  const PromotersEvent();
  @override
  List<Object?> get props => [];
}

class PromotersLoaded extends PromotersEvent {}

class PromotersSearchChanged extends PromotersEvent {
  final String query;
  const PromotersSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class PromotersPageChanged extends PromotersEvent {
  final int page;
  const PromotersPageChanged(this.page);
  @override
  List<Object?> get props => [page];
}
