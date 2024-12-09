import 'package:esg_post_office/features/image_to_json/presentation/widgets/image_to_json_widget.dart';
import 'package:flutter/material.dart';

class PublicTransportPage extends StatelessWidget {
  const PublicTransportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Transport'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transport Stats',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          icon: Icons.directions_bus,
                          value: '0',
                          label: 'Trips',
                        ),
                        _StatItem(
                          icon: Icons.co2,
                          value: '0 kg',
                          label: 'CO₂ Saved',
                        ),
                        _StatItem(
                          icon: Icons.eco,
                          value: '0',
                          label: 'Credits',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Transport Options',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    const ListTile(
                      leading: Icon(Icons.directions_bus),
                      title: Text('Bus'),
                      subtitle: Text('Earn Atoms per trip'),
                    ),
                    ImageToJsonWidget(
                      customPrompt:
                          "Give distance travelled in km in JSON response, it should be in the format of {'distance': 10} and it is found after the text : KMs ussualy ",
                      onJsonResult: (jsonResponse) {
                        // Handle the JSON response here
                        print(jsonResponse);
                      },
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Trips',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text('No recent trips'),
                subtitle: Text('Start using public transport to earn credits!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
