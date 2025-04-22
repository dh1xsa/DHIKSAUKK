import 'package:carousel_slider/carousel_slider.dart';
import 'package:coba1/color.dart';
import 'package:coba1/model/facility.dart';
import 'package:coba1/model/image_viewer_helper.dart';
import 'package:coba1/widget/custom_appbar.dart';
import 'package:coba1/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> facilityImages = AppData.innerStyleImages;
  final LatLng hotelLocation = LatLng(-7.171752592803174, 107.88995691093722);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar(),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Hotel Hebat",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items:
                facilityImages.map((imageUrl) {
                  return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ImageViewerHelper.show(
                              context: context,
                              url: imageUrl,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                  );
                }).toList(),
            ),
            const SizedBox(height: 40),
            const Text(
              "About Us",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "Hotel Insitu Garut Syariah is the best accommodation choice in the heart of Garut city that carries the concept of modern sharia. With a calm, clean, and comfortable atmosphere, we present a stay experience that is not only pleasant, but also in accordance with Islamic values.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 40),
            const Text(
              "Our Location",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),
            Container(
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: hotelLocation,
                  initialZoom: 16,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  )
                ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.HotelInSitu',
                    ),
                    MarkerLayer(
                        markers: [
                          Marker(
                              point: hotelLocation,
                              width: 80,
                              height: 80,
                              child: Icon(Icons.location_on, color: Colors.red, size: 40),
                          ),
                        ],
                    ),
                  ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
