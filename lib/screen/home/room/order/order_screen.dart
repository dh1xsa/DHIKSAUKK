import 'package:coba1/color.dart';
import 'package:coba1/screen/home/room/order/credit_card.dart';
import 'package:coba1/widget/my_button.dart';
import 'package:coba1/widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HotelOrderFormPage extends StatefulWidget {
  final String selectedRoomType;

  const HotelOrderFormPage({super.key, required this.selectedRoomType});

  @override
  State<HotelOrderFormPage> createState() => _HotelOrderFormPageState();
}

class _HotelOrderFormPageState extends State<HotelOrderFormPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final checkInController = TextEditingController();
  final checkOutController = TextEditingController();

  String? selectedRoomType;

  @override
  void initState() {
    super.initState();
    selectedRoomType = widget.selectedRoomType;
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        checkInController.text = "${picked.day}/${picked.month}/${picked.year}";
        checkOutController.clear();
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    if (checkInController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Check-In date first')),
      );
      return;
    }

    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final DateTime checkInDate = dateFormat.parse(checkInController.text);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate.add(const Duration(days: 1)),
      firstDate: checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        checkOutController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void submitOrder() async {
    final name = nameController.text;
    final email = emailController.text;
    final phone = phoneController.text;
    final checkIn = checkInController.text;
    final checkOut = checkOutController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        checkIn.isEmpty ||
        checkOut.isEmpty ||
        selectedRoomType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields must be filled')),
      );
      return;
    }

    try {
      final supabase = Supabase.instance.client;
      final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      final DateTime checkInDate = dateFormat.parse(checkIn);
      final DateTime checkOutDate = dateFormat.parse(checkOut);

      if (checkOutDate.isBefore(checkInDate)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid Check-Out date')));
        return;
      }

      final existingReservations = await supabase
          .from('pesanan_hotel')
          .select()
          .gte('check_in', checkInDate.toIso8601String())
          .lte('check_out', checkOutDate.toIso8601String());

      if (existingReservations.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The selected dates are already booked'),
          ),
        );
        return;
      }

      final room =
          await supabase
              .from('rooms')
              .select('stock')
              .eq('type', selectedRoomType!)
              .single();

      final int currentStock = room['stock'] ?? 0;

      if (currentStock <= 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Room not available')));
        return;
      }

      final updatedStock = currentStock - 1;

      await supabase
          .from('rooms')
          .update({'stock': updatedStock})
          .eq('type', selectedRoomType!);

      final response =
          await supabase
              .from('pesanan_hotel')
              .insert([
                {
                  'nama_lengkap': name,
                  'email': email,
                  'no_hp': phone,
                  'check_in': checkInDate.toIso8601String(),
                  'check_out': checkOutDate.toIso8601String(),
                  'jenis_kamar': selectedRoomType,
                  'status': 'pending',
                },
              ])
              .select()
              .single();

      if (response is Map<String, dynamic> && response['error'] != null) {
        throw response['error'];
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaymentScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save booking: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 64,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Order Room',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildLabel("Full Name"),
            MyTextField(
              controller: nameController,
              hintText: 'Full Name',
              obscureText: false,
            ),
            const SizedBox(height: 15),
            buildLabel("Email"),
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 15),
            buildLabel("Phone Number"),
            MyTextField(
              controller: phoneController,
              hintText: 'Phone Number',
              obscureText: false,
            ),
            const SizedBox(height: 15),
            buildLabel("Room Type"),
            MyTextField(
              controller: TextEditingController(text: selectedRoomType),
              hintText: selectedRoomType ?? 'Select Room Type',
              obscureText: false,
            ),
            const SizedBox(height: 25),
            buildLabel("Check-In Date"),
            GestureDetector(
              onTap: () => _selectCheckInDate(context),
              child: AbsorbPointer(
                child: MyTextField(
                  controller: checkInController,
                  hintText: 'Check-In Date',
                  obscureText: false,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(height: 10),
            buildLabel("Check-Out Date"),
            GestureDetector(
              onTap: () => _selectCheckOutDate(context),
              child: AbsorbPointer(
                child: MyTextField(
                  controller: checkOutController,
                  hintText: 'Check-Out Date',
                  obscureText: false,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(height: 25),
            MyButton(text: 'Order Now', onTap: submitOrder),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
