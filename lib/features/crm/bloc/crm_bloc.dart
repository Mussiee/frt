import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/mock_customers.dart';
import 'crm_event.dart';
import 'crm_state.dart';

class CrmBloc extends Bloc<CrmEvent, CrmState> {
  List<MockCustomer> _all = [];

  CrmBloc() : super(CrmInitial()) {
    on<CrmLoaded>(_onLoaded);
    on<CrmFilterChanged>(_onFilterChanged);
    on<CrmSearchChanged>(_onSearchChanged);
  }

  void _onLoaded(CrmLoaded event, Emitter<CrmState> emit) {
    _all = List.of(mockCustomers);
    emit(_buildSuccess(filter: 'ALL', search: ''));
  }

  void _onFilterChanged(CrmFilterChanged event, Emitter<CrmState> emit) {
    if (state is CrmLoadSuccess) {
      final s = state as CrmLoadSuccess;
      emit(_buildSuccess(filter: event.filter, search: s.search));
    }
  }

  void _onSearchChanged(CrmSearchChanged event, Emitter<CrmState> emit) {
    if (state is CrmLoadSuccess) {
      final s = state as CrmLoadSuccess;
      emit(_buildSuccess(filter: s.filter, search: event.query));
    }
  }

  CrmLoadSuccess _buildSuccess({required String filter, required String search}) {
    var list = _all.toList();
    if (filter != 'ALL') {
      list = list.where((c) {
        switch (filter) {
          case 'VIP':
            return c.tier == 'VIP GOLD' || c.tier == 'PLATINUM';
          case 'RETURNING':
            return c.tier == 'MEMBER';
          case 'NEW':
            return c.tier == 'NEW';
          case 'NO SHOW':
            return c.totalSpend == 0.0;
          default:
            return true;
        }
      }).toList();
    }
    if (search.isNotEmpty) {
      list = list.where((c) => c.name.toLowerCase().contains(search.toLowerCase())).toList();
    }
    return CrmLoadSuccess(
      customers: _all,
      filtered: list,
      filter: filter,
      search: search,
    );
  }
}
