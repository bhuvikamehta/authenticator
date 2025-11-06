import 'package:flutter/material.dart';
import 'package:auth_app/Components/animated_delete_button.dart';
import 'package:auth_app/Models/totp_card.dart';
import 'package:auth_app/services/totp_storage_service.dart';

class TotpCardWidget extends StatelessWidget {
  final TotpCard totpCard;
  final VoidCallback onDeleted;

  const TotpCardWidget({
    super.key,
    required this.totpCard,
    required this.onDeleted,
  });

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete TOTP'),
        content: Text('Are you sure you want to delete ${totpCard.issuer}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final storage = TotpStorageService();
      await storage.deleteTotpCard(totpCard.id);
      onDeleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        totpCard.issuer,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        totpCard.accountName,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ThemedDeleteButton(
                  onPressed: () async {
                    await _handleDelete(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '000 000',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
