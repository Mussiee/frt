import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/mock_promoters.dart';
import 'promoters_event.dart';
import 'promoters_state.dart';

class PromotersBloc extends Bloc<PromotersEvent, PromotersState> {
  static const int _pageSize = 5;
  List<MockPromoter> _all = [];

  PromotersBloc() : super(PromotersInitial()) {
    on<PromotersLoaded>(_onLoaded);
    on<PromotersSearchChanged>(_onSearchChanged);
    on<PromotersPageChanged>(_onPageChanged);
  }

  void _onLoaded(PromotersLoaded event, Emitter<PromotersState> emit) {
    _all = List.of(mockPromoters);
    emit(_buildSuccess(search: '', page: 1));
  }

  void _onSearchChanged(PromotersSearchChanged event, Emitter<PromotersState> emit) {
    emit(_buildSuccess(search: event.query, page: 1));
  }

  void _onPageChanged(PromotersPageChanged event, Emitter<PromotersState> emit) {
    if (state is PromotersLoadSuccess) {
      final s = state as PromotersLoadSuccess;
      emit(_buildSuccess(search: s.search, page: event.page));
    }
  }

  PromotersLoadSuccess _buildSuccess({required String search, required int page}) {
    var list = _all.toList();
    if (search.isNotEmpty) {
      list = list.where((p) => p.name.toLowerCase().contains(search.toLowerCase())).toList();
    }
    final totalPages = (list.length / _pageSize).ceil().clamp(1, 99);
    return PromotersLoadSuccess(
      promoters: _all,
      filtered: list,
      search: search,
      page: page,
      totalPages: totalPages,
    );
  }
}
