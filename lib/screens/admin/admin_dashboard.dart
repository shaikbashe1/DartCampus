import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: isDark ? AppColors.navy : AppColors.cardLight,
            extended: true,
            selectedIndex: 0,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('Manage Students')),
              NavigationRailDestination(icon: Icon(Icons.menu_book), label: Text('Manage Lessons')),
              NavigationRailDestination(icon: Icon(Icons.code), label: Text('Manage Challenges')),
            ],
            onDestinationSelected: (index) {},
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Admin Dashboard', style: Theme.of(context).textTheme.displayMedium),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        onPressed: () {
                          Provider.of<AuthService>(context, listen: false).signOut();
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      _buildAdminStatCard(context, 'Total Students', '142', Icons.people, AppColors.teal),
                      const SizedBox(width: 16),
                      _buildAdminStatCard(context, 'Active Challenges', '64', Icons.code, AppColors.violet),
                      const SizedBox(width: 16),
                      _buildAdminStatCard(context, 'Avg Success Rate', '72%', Icons.analytics, Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAdminStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 16),
              Text(value, style: Theme.of(context).textTheme.displayMedium),
              Text(title, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
