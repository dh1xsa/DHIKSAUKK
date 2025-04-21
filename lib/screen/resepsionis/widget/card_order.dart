import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OrderCard extends StatelessWidget {
  final dynamic data;
  final List<String> statusOptions;
  final Function(String) onStatusChanged;

  const OrderCard({
    super.key,
    required this.data,
    required this.statusOptions,
    required this.onStatusChanged,
  });

  Color getStatusColor(String status) {
    switch (status) {
      case 'success':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'done':
        return Colors.blueGrey;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStatus = data['status'] ?? 'pending';

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['nama_lengkap'] ?? 'Tanpa Nama',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Iconsax.sms, data['email']),
            const SizedBox(height: 2),
            _buildInfoRow(Iconsax.call, data['no_hp']),
            const SizedBox(height: 2),
            _buildInfoRow(Iconsax.home, 'Kamar: ${data['jenis_kamar'] ?? ''}'),
            const SizedBox(height: 2),
            _buildInfoRow(Iconsax.calendar_1, 'Check-in: ${data['check_in'] ?? ''}'),
            const SizedBox(height: 2),
            _buildInfoRow(Iconsax.calendar_remove, 'Check-out: ${data['check_out'] ?? ''}'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor(currentStatus).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        currentStatus.toUpperCase(),
                        style: TextStyle(
                          color: getStatusColor(currentStatus),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: currentStatus,
                  dropdownColor: Colors.white,
                  items: statusOptions.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null && newValue != currentStatus) {
                      onStatusChanged(newValue);
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
