import 'package:coba1/screen/admin/screen_admin/room_admin/room_add.dart';
import 'package:coba1/screen/admin/widget_admin/drawer_admin.dart';
import 'package:coba1/screen/admin/widget_admin/roomcard.dart';
import 'package:flutter/material.dart';
import 'package:coba1/color.dart';
import 'package:coba1/widget/my_button.dart';
import 'package:coba1/widget/custom_appbar.dart';
import 'package:coba1/screen/admin/screen_admin/room_admin/edit_room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomViewScreen extends StatefulWidget {
  @override
  _RoomViewScreenState createState() => _RoomViewScreenState();
}

class _RoomViewScreenState extends State<RoomViewScreen> {
  List<Map<String, dynamic>> rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
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

  Future<void> _deleteRoom(int index) async {
    final roomId = rooms[index]['id'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this Room?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () async {
                Navigator.of(context).pop();

                try {
                  await Supabase.instance.client
                      .from('rooms')
                      .delete()
                      .eq('id', roomId);

                  setState(() {
                    rooms.removeAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rooms successfully deleted')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete Rooms: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editRoom(int index) {
    final roomId = rooms[index]['id'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRoomScreen(roomId: roomId),
      ),
    ).then((_) => _fetchRooms());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar(),
      drawer: MyDrawerAdmin(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room List',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: rooms.isEmpty
                    ? Center(child: Text("There is no room data yet."))
                    : ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    final facilities = room['facilities'] ?? '';
                    return RoomCard(
                      type: room['type'] ?? 'Unknown',
                      price: room['price'] ?? 0,
                      stock: room['stock'] ?? 0,
                      facilities: facilities,
                      onEdit: () => _editRoom(index),
                      onDelete: () => _deleteRoom(index),
                    );
                  },
                ),
              ),
            MyButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRoomScreen()),
                ).then((_) => _fetchRooms());
              },
              text: "Add Room",
            ),
          ],
        ),
      ),
    );
  }
}
