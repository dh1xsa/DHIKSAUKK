import 'package:coba1/screen/home/facility/card_facilities.dart';
import 'package:coba1/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:coba1/color.dart';
import 'package:coba1/widget/custom_appbar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FacilityScreen extends StatefulWidget {
  @override
  _FacilityScreenState createState() => _FacilityScreenState();
}

class _FacilityScreenState extends State<FacilityScreen> {
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
        SnackBar(content: Text('Gagal mengambil data fasilitas: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar(),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our Facilities',
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
                    return CardFacilities(
                      facilityName: facility['name'] ?? 'Tanpa Nama',
                      description: facility['description'] ?? 'Tanpa Deskripsi',
                      icon: Iconsax.building,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
