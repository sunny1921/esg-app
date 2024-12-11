import 'package:esg_post_office/features/image_to_json/presentation/widgets/image_to_json_widget.dart';
import 'package:esg_post_office/features/record/presentation/providers/record_state.dart';
import 'package:esg_post_office/features/record/presentation/providers/bills_provider.dart';
import 'package:esg_post_office/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FuelBillPage extends ConsumerStatefulWidget {
  const FuelBillPage({super.key});

  @override
  ConsumerState<FuelBillPage> createState() => _FuelBillPageState();
}

class _FuelBillPageState extends ConsumerState<FuelBillPage> {
  String get _promptForFuelBill => '''
Please analyze this fuel bill and provide the following information in a valid JSON format:
{
  "litresConsumed": <extract number of litres as a number>,
  "billNumber": "<extract bill number as text>"
}
Example output:
{
  "litresConsumed": 19.70,
  "billNumber": "FB123456"
}
''';

  void _handleJsonResult(Map<String, dynamic> data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(fuelBillProvider.notifier)
          ..setLoading(false)
          ..setBillData(data);
      }
    });
  }

  Future<void> _submitBill() async {
    final billState = ref.read(fuelBillProvider);
    final authState = ref.read(authStateProvider);
    final billsService = ref.read(billsServiceProvider);

    try {
      if (billState.billData == null) {
        throw Exception('No bill data available');
      }

      final user = authState.value;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      ref.read(fuelBillProvider.notifier).setLoading(true);

      await billsService.submitFuelBill(
        postOfficeId: user.postOfficeId,
        billData: billState.billData!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fuel bill submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        ref.read(fuelBillProvider.notifier).reset();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        ref.read(fuelBillProvider.notifier).setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final billState = ref.watch(fuelBillProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Bill Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ImageToJsonWidget(
              customPrompt: _promptForFuelBill,
              onJsonResult: _handleJsonResult,
            ),
            if (billState.error != null)
              Text(
                billState.error!,
                style: const TextStyle(color: Colors.red),
              ),
            if (billState.billData != null) ...[
              const SizedBox(height: 20),
              const Text(
                'Extracted Data:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: billState.billData!.length,
                  itemBuilder: (context, index) {
                    String key = billState.billData!.keys.elementAt(index);
                    dynamic value = billState.billData![key];
                    return ListTile(
                      title: Text(key),
                      subtitle: Text(value.toString()),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: billState.billData == null || billState.isProcessing || billState.isUploading
                    ? null 
                    : _submitBill,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: billState.isProcessing || billState.isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text(
                        'Submit Bill',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
