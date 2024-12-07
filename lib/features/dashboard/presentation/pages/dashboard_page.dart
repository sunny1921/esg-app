import 'package:esg_post_office/core/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esg_post_office/features/auth/presentation/providers/auth_provider.dart';
import 'package:esg_post_office/features/auth/presentation/pages/sign_in_page.dart';
import 'package:esg_post_office/core/widgets/app_drawer.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.read(bottomNavVisibilityProvider.notifier).state = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const SignInPage();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => ref.read(authStateProvider.notifier).signOut(),
              ),
            ],
          ),
          drawer: AppDrawer(user: user),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${user.name}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),
                _buildLocalPostOfficeMetrics(),
                const SizedBox(height: 24),
                if (user.isEmployee) ...[
                  _buildUpcomingEvents(),
                  const SizedBox(height: 24),
                  _buildAlerts(),
                ] else ...[
                  _buildLiveTickets(),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildLocalPostOfficeMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ESG Metrics of Your Post Office',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.electric_bolt,
                    title: 'Electricity',
                    value: '150 kWh',
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.water_drop,
                    title: 'Water',
                    value: '45 L',
                  ),
                ),
                Expanded(
                  child: _buildMetricItem(
                    icon: Icons.local_shipping,
                    title: 'Fleet',
                    value: '25 km',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildEventItem(
              title: 'Staff Meeting',
              date: 'Tomorrow, 10:00 AM',
              description:
                  'Monthly staff meeting to discuss performance metrics',
            ),
            const Divider(),
            _buildEventItem(
              title: 'ESG Training',
              date: 'Next Week, Tuesday',
              description: 'Training session on new ESG initiatives',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlerts() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alerts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAlertItem(
              title: 'High Priority Complaint',
              description: 'Customer reported missing registered mail',
              severity: 'High',
            ),
            const Divider(),
            _buildAlertItem(
              title: 'System Maintenance',
              description: 'Scheduled maintenance tonight at 10 PM',
              severity: 'Medium',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveTickets() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Tickets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTicketItem(
              id: 'TK001',
              status: 'In Transit',
              type: 'Parcel',
              lastUpdate: '2 hours ago',
            ),
            const Divider(),
            _buildTicketItem(
              id: 'TK002',
              status: 'Processing',
              type: 'Money Order',
              lastUpdate: '1 day ago',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF1B5E20),
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEventItem({
    required String title,
    required String date,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(description),
      ],
    );
  }

  Widget _buildAlertItem({
    required String title,
    required String description,
    required String severity,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color:
                    severity == 'High' ? Colors.red[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                severity,
                style: TextStyle(
                  color:
                      severity == 'High' ? Colors.red[900] : Colors.orange[900],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(description),
      ],
    );
  }

  Widget _buildTicketItem({
    required String id,
    required String status,
    required String type,
    required String lastUpdate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Ticket $id',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          type,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text('Last update: $lastUpdate'),
      ],
    );
  }
}
