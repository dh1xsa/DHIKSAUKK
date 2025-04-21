import 'package:coba1/color.dart';
import 'package:coba1/screen/home/room/order/order_screen.dart';
import 'package:coba1/screen/home/room/widget_room/card_room_widget.dart';
import 'package:coba1/widget/custom_appbar.dart';
import 'package:coba1/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomScreen extends StatefulWidget {
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  List<Map<String, dynamic>> rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await Supabase.instance.client
          .from('rooms')
          .select()
          .order('id', ascending: true);

      setState(() {
        rooms = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching rooms: $e')),
      );
    }
  }

  void onSelect(Map<String, dynamic> room) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected room: ${room['type']}')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HotelOrderFormPage(
          selectedRoomType: room['type'], // Pass room type here
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar(),
      drawer: MyDrawer(),
      body: RefreshIndicator(
        onRefresh: _fetchRooms, // Trigger room reload when pulled down
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : rooms.isEmpty
            ? Center(child: Text('No rooms available.'))
            : ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            final imageUrl = room['image_url'] ?? 'https://lh3.googleusercontent.com/p/AF1QipMmL1GxkwccU-FOlxVjw6rXbCOrEKPmA7mm6lDC=w252-h168-k-no';
            return RoomCardView(
              room: room,
              imageUrl: imageUrl,
              onSelect: () => onSelect(room),
            );
          },
        ),
      ),
    );
  }
}

