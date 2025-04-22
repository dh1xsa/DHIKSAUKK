import 'package:flutter/material.dart';

class CardFacilities extends StatelessWidget {
  final String facilityName;
  final String description;
  final IconData icon;

  const CardFacilities({
    Key? key,
    required this.facilityName,
    required this.description,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Icon(icon, size: 40, color: Colors.black87),
        title: Text(
          facilityName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(description),
      ),
    );
  }
}
