import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScannerState extends Equatable {
  final String? scanResult;
  final String? lastScannedName;

  const ScannerState({this.scanResult, this.lastScannedName});

  @override
  List<Object?> get props => [scanResult, lastScannedName];
}

class ScannerCubit extends Cubit<ScannerState> {
  int _scanIndex = 0;

  static const _mockResults = [
    {'result': 'valid', 'name': 'Julian Casablancas'},
    {'result': 'invalid', 'name': 'Unknown Guest'},
    {'result': 'already_used', 'name': 'Marcus Thorne'},
  ];

  ScannerCubit() : super(const ScannerState());

  void simulateScan() {
    final mock = _mockResults[_scanIndex % _mockResults.length];
    _scanIndex++;
    emit(ScannerState(
      scanResult: mock['result'],
      lastScannedName: mock['name'],
    ));
  }

  void resetScan() {
    emit(const ScannerState());
  }
}
