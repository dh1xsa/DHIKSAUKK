import 'package:coba1/widget/my_button.dart';
import 'package:flutter/material.dart';

class RoomCardView extends StatelessWidget {
  final Map<String, dynamic> room;
  final String imageUrl;
  final Function onSelect;

  const RoomCardView({
    Key? key,
    required this.room,
    required this.imageUrl,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 8.0, // Menambahkan bayangan lebih dalam untuk efek depth
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0), // Rounded corners for image
              child: Image.network(
                imageUrl,
                height: 180.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              room['type'] ?? 'No Type',
              style: TextStyle(
                fontSize: 22.0, // Menambah ukuran font untuk kesan lebih bold
                fontWeight: FontWeight.w600, // Menggunakan weight sedikit lebih ringan
                color: Colors.black87, // Warna sedikit lebih soft
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stock: ${room['stock']}',
                  style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                ),
                Text(
                  'Price: \$${room['price']}',
                  style: TextStyle(fontSize: 14.0, color: Colors.green[700]),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Facilities: ${room['facilities'] ?? 'N/A'}',
              style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
            ),
            SizedBox(height: 16.0),
            MyButton(
              onTap: () => onSelect(),
              text: "Order Now",
            ),
          ],
        ),
      ),
    );
  }
}
