// lib/routers.dart

import 'package:flutter/material.dart';

// ── Auth / Core ───────────────────────────────────────────────────────────────
import 'package:vital_application/features/auth/auth_page.dart';
import 'package:vital_application/features/user/home/home_page.dart';
import 'package:vital_application/features/recp/recover_page.dart';
import 'package:vital_application/features/splash/splash_page.dart';

// ── Select Role ───────────────────────────────────────────────────────────────
import 'package:vital_application/features/select_role/select_role_page.dart';

// ── User Flow ─────────────────────────────────────────────────────────────────
import 'package:vital_application/features/user/menu/user_menu_page.dart';
import 'package:vital_application/features/user/occurrences/new_occurrences_page.dart';
import 'package:vital_application/features/user/tracking/user_tracking_page.dart';
import 'package:vital_application/features/user/history/user_history_page.dart';

// ── Ops Flow ──────────────────────────────────────────────────────────────────
import 'package:vital_application/features/ops/dashboard/ops_dashboard_page.dart';
import 'package:vital_application/features/ops/details/ops_incident_details_page.dart';
import 'package:vital_application/features/ops/assigned/ops_assigned_page.dart';
import 'package:vital_application/features/ops/navigation/ops_navigation_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ROTAS
// ─────────────────────────────────────────────────────────────────────────────

abstract class AppRoutes {

  // Legado
  static const String home   = '/home';
  static const String splash = '/splash';
  static const String login  = '/login';
  static const String recp   = '/recp';

  // Select role
  static const String selectRole = '/';

  // User
  static const String userMenu     = '/user';
  static const String openIncident = '/open-incident';
  static const String tracking     = '/tracking';
  static const String history      = '/history';

  // Ops
  static const String opsDashboard   = '/ops';
  static const String opsIncident    = '/ops/incident';
  static const String opsAssigned    = '/ops/assigned';
  static const String opsNavigation  = '/ops/navigation';
  static const String opsFinalService = '/ops/final-service';
}

// ─────────────────────────────────────────────────────────────────────────────
// GERADOR
// ─────────────────────────────────────────────────────────────────────────────

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

    // ── Legado ──────────────────────────────────────────────────────────────
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.recp:
        return MaterialPageRoute(builder: (_) => RecoverPage());

    // ── Select role ─────────────────────────────────────────────────────────
      case AppRoutes.selectRole:
        return MaterialPageRoute(builder: (_) => const SelectRolePage());

    // ── User ────────────────────────────────────────────────────────────────
      case AppRoutes.userMenu:
        return MaterialPageRoute(builder: (_) => const UserMenuPage());
      case AppRoutes.openIncident:
        return MaterialPageRoute(builder: (_) => const NewOccurrencesPage());
      case AppRoutes.tracking:
        return MaterialPageRoute(builder: (_) => const UserTrackingPage());
      case AppRoutes.history:
        return MaterialPageRoute(builder: (_) => const UserHistoryPage());

    // ── Ops ─────────────────────────────────────────────────────────────────
      case AppRoutes.opsDashboard:
        return MaterialPageRoute(builder: (_) => const OpsDashboardPage());
      case AppRoutes.opsIncident:
      // OcorrenciaModel passada via arguments
        return MaterialPageRoute(
          builder: (_) => const OpsIncidentDetailsPage(),
          settings: settings,
        );
      case AppRoutes.opsAssigned:
        return MaterialPageRoute(builder: (_) => const OpsAssignedPage());
      case AppRoutes.opsNavigation:
        return MaterialPageRoute(builder: (_) => const OpsNavigationPage());
      case AppRoutes.opsFinalService:
      // Implementar OpsFinalServicePage quando necessário
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Finalizar Atendimento'),
              backgroundColor: Color(0xFFC81D25),
            ),
            body: const Center(child: Text('Em desenvolvimento')),
          ),
        );

    // ── Fallback ────────────────────────────────────────────────────────────
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}