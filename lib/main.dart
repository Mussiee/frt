import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/reservations/bloc/reservations_bloc.dart';
import 'features/reservations/bloc/reservations_event.dart';
import 'features/tables/bloc/floor_view_bloc.dart';
import 'features/tables/bloc/floor_view_event.dart';
import 'features/event_requests/bloc/event_requests_bloc.dart';
import 'features/event_requests/bloc/event_requests_event.dart';
import 'features/promoters/bloc/promoters_bloc.dart';
import 'features/promoters/bloc/promoters_event.dart';
import 'features/crm/bloc/crm_bloc.dart';
import 'features/crm/bloc/crm_event.dart';
import 'features/notifications/cubit/notifications_cubit.dart';
import 'features/security/cubit/scanner_cubit.dart';
import 'shared/cubit/role_cubit.dart';
import 'firebase_options.dart';
import 'utils/theme/app_theme.dart';
import 'utils/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FocusApp());
}

class FocusApp extends StatelessWidget {
  const FocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(repository: AuthRepository())),
        BlocProvider(create: (_) => RoleCubit()),
        BlocProvider(create: (_) => ReservationsBloc()..add(ReservationsLoaded())),
        BlocProvider(create: (_) => FloorViewBloc()..add(FloorViewLoaded())),
        BlocProvider(create: (_) => EventRequestsBloc()..add(EventRequestsLoaded())),
        BlocProvider(create: (_) => PromotersBloc()..add(PromotersLoaded())),
        BlocProvider(create: (_) => CrmBloc()..add(CrmLoaded())),
        BlocProvider(create: (_) => NotificationsCubit()..load()),
        BlocProvider(create: (_) => ScannerCubit()),
      ],
      child: MaterialApp.router(
        title: 'Focus',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
