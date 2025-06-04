import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../services/database_service.dart';
import '../models/report_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const ReportsListPage(),
    const NewReportPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return authState.when(
      data: (user) => Scaffold(
        appBar: AppBar(
          title: const Text('ADSD Maintenance'),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.account_circle),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('${user?.username ?? ''} (${user?.role ?? ''})'),
                  enabled: false,
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                  },
                ),
              ],
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: 'New Report',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}

class ReportsListPage extends ConsumerStatefulWidget {
  const ReportsListPage({super.key});

  @override
  ConsumerState<ReportsListPage> createState() => _ReportsListPageState();
}

class _ReportsListPageState extends ConsumerState<ReportsListPage> {
  List<MaintenanceReport> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedReports = await DatabaseService.instance.getAllReports();
      setState(() {
        reports = loadedReports;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading reports: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (reports.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No reports yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Create your first maintenance report!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReports,
      child: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: report.isSync ? Colors.green : Colors.orange,
                child: Icon(
                  report.isSync ? Icons.cloud_done : Icons.cloud_upload,
                  color: Colors.white,
                ),
              ),
              title: Text(report.reportId),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(report.customerName),
                  Text(
                    '${report.instrumentName} - ${report.instrumentManufacturer}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    report.createdAt.day.toString().padLeft(2, '0') +
                        '/${report.createdAt.month.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    report.problemSolved == 'Yes' ? 'Solved' : 'Pending',
                    style: TextStyle(
                      fontSize: 10,
                      color: report.problemSolved == 'Yes' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () {
                // Navigate to report details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportDetailsPage(report: report),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class NewReportPage extends StatelessWidget {
  const NewReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'New Report Form',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Report form will be implemented here',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Sync with Server'),
          subtitle: const Text('Upload pending reports and download new data'),
          onTap: () {
            // Implement manual sync
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sync functionality coming soon')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.storage),
          title: const Text('Local Storage'),
          subtitle: const Text('Manage offline data'),
          onTap: () {
            // Show storage info
          },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          subtitle: const Text('App version and information'),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'ADSD Maintenance',
              applicationVersion: '1.0.0',
              applicationLegalese: 'Made with CloudTech © 2025',
            );
          },
        ),
      ],
    );
  }
}

class ReportDetailsPage extends StatelessWidget {
  final MaintenanceReport report;

  const ReportDetailsPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report ${report.reportId}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Name', report.customerName),
                    _buildDetailRow('Type', report.customerType),
                    _buildDetailRow('Phone', report.customerTelephone),
                    _buildDetailRow('City', report.city),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Equipment Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Instrument', report.instrumentName),
                    _buildDetailRow('Manufacturer', report.instrumentManufacturer),
                    _buildDetailRow('Serial Number', report.serialNumber),
                    _buildDetailRow('S.W.Version', report.swVersion),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Problem Description', report.problemDescription),
                    _buildDetailRow('Problem Solved', report.problemSolved),
                    _buildDetailRow('Remedy Description', report.remedyDescription),
                    _buildDetailRow('Technician', report.technicianName),
                  ],
                ),
              ),
            ),
            if (report.materials.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Materials Used',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      ...report.materials.map((material) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(material.materialName),
                            ),
                            Expanded(
                              child: Text('Qty: ${material.quantity}'),
                            ),
                            if (material.remarks.isNotEmpty)
                              Expanded(
                                child: Text(material.remarks),
                              ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} 