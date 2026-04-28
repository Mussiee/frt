import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TableDetailState extends Equatable {
  final String notes;
  final String spendAmount;
  final bool isTableFree;

  const TableDetailState({
    this.notes = '',
    this.spendAmount = '',
    this.isTableFree = false,
  });

  @override
  List<Object?> get props => [notes, spendAmount, isTableFree];
}

class TableDetailCubit extends Cubit<TableDetailState> {
  TableDetailCubit() : super(const TableDetailState());

  void updateNotes(String notes) {
    emit(TableDetailState(
      notes: notes,
      spendAmount: state.spendAmount,
      isTableFree: state.isTableFree,
    ));
  }

  void updateSpend(String spendAmount) {
    emit(TableDetailState(
      notes: state.notes,
      spendAmount: spendAmount,
      isTableFree: state.isTableFree,
    ));
  }

  void markTableAsFree() {
    emit(TableDetailState(
      notes: state.notes,
      spendAmount: state.spendAmount,
      isTableFree: true,
    ));
  }
}
