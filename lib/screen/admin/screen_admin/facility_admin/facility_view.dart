import 'package:coba1/screen/admin/screen_admin/facility_admin/edit_facility.dart';
import 'package:coba1/screen/admin/screen_admin/facility_admin/facility_add.dart';
import 'package:coba1/screen/admin/widget_admin/drawer_admin.dart';
import 'package:coba1/screen/admin/widget_admin/facilityhotelcard.dart';
import 'package:flutter/material.dart';
import 'package:coba1/color.dart';
import 'package:coba1/widget/my_button.dart';
import 'package:coba1/widget/custom_appbar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FacilityViewScreen extends StatefulWidget {
  @override
  _FacilityViewScreenState createState() => _FacilityViewScreenState();
}

class _FacilityViewScreenState extends State<FacilityViewScreen> {
  List<Map<String, dynamic>> facilities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFacilities();
  }

  Future<void> _fetchFacilities() async {
    try {
      final data = await Supabase.instance.client
          .from('facility')
          .select()
          .order('id', ascending: true);

      setState(() {
        facilities = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to retrieve facility data: $e')),
      );
    }
  }

  Future<void> _deleteFacility(int index) async {
    final facilityId = facilities[index]['id'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this feature?"),
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
                Navigator.of(context).pop(); // Close the dialog

                try {
                  await Supabase.instance.client
                      .from('facility')
                      .delete()
                      .eq('id', facilityId);

                  setState(() {
                    facilities.removeAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Facility successfully deleted')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete facility: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editFacility(Map<String, dynamic> facility) {
    final facilityId = facility['id'];
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateFacilityScreen(facilityId: facilityId)
      ),
    ).then((_) => _fetchFacilities());
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
            const Text(
              'Daftar Fasilitas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: facilities.isEmpty
                    ? const Center(child: Text("Belum ada fasilitas yang ditambahkan."))
                    : ListView.builder(
                  itemCount: facilities.length,
                  itemBuilder: (context, index) {
                    final facility = facilities[index];
                    return FacilityCardHotel(
                      facilityName: facility['name'] ?? 'Tanpa Nama',
                      description: facility['description'] ?? 'Tanpa Deskripsi',
                      icon: Iconsax.building,
                      onEdit: () => _editFacility(facility),
                      onDelete: () => _deleteFacility(index),
                    );
                  },
                ),
              ),
            MyButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFacilityScreen()),
                ).then((_) => _fetchFacilities());
              },
              text: "Add Facility",
            ),
          ],
        ),
      ),
    );
  }
}