import 'package:equatable/equatable.dart';

abstract class CrmEvent extends Equatable {
  const CrmEvent();
  @override
  List<Object?> get props => [];
}

class CrmLoaded extends CrmEvent {}

class CrmFilterChanged extends CrmEvent {
  final String filter;
  const CrmFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}

class CrmSearchChanged extends CrmEvent {
  final String query;
  const CrmSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}
