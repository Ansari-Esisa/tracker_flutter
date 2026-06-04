import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/vehicle/presentation/vehicle_list_screen.dart';
import '../../features/main_layout.dart';

import '../../features/fuel/presentation/fuel_list_screen.dart';
import '../../features/fuel/presentation/add_fuel_screen.dart';
import '../../features/maintenance/presentation/maintenance_list_screen.dart';
import '../../features/maintenance/presentation/add_maintenance_screen.dart';
import '../../features/vehicle/presentation/add_vehicle_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/vehicles',
          builder: (context, state) => const VehicleListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) => const AddVehicleScreen(),
            ),
            GoRoute(
              path: ':vehicleId/fuel',
              builder: (context, state) => FuelListScreen(
                vehicleId: state.pathParameters['vehicleId']!,
              ),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => AddFuelScreen(
                    vehicleId: state.pathParameters['vehicleId']!,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: ':vehicleId/maintenance',
              builder: (context, state) => MaintenanceListScreen(
                vehicleId: state.pathParameters['vehicleId']!,
              ),
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) => AddMaintenanceScreen(
                    vehicleId: state.pathParameters['vehicleId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
