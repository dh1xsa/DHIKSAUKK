import 'package:coba1/color.dart';
import 'package:coba1/widget/my_back_button.dart';
import 'package:coba1/widget/my_button.dart';
import 'package:coba1/widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _facilitiesController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final type = _typeController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;


    final facilities = _facilitiesController.text.trim().split(',')
        .map((facility) => facility.trim())
        .join(',');
    try {
      final response = await Supabase.instance.client
          .from('rooms')
          .insert({
        'type': type,
        'price': price,
        'stock': stock,
        'facilities': facilities,
      })
          .select();

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room successfully added!')),
        );
        Navigator.pop(context);
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add room: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _typeController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _facilitiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 64,
        leading: BackButtonWidget(onPressed: () => Navigator.pop(context)),
        centerTitle: true,
        title: const Text(
          "Room",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 25),
              MyTextField(
                controller: _typeController,
                hintText: 'Type Room',
                obscureText: false,
                validator: (val) => val == null || val.isEmpty ? 'Required fields' : null,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _priceController,
                hintText: 'Price',
                keyboardType: TextInputType.number,
                obscureText: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Only digits allowed
                ],
                validator: (val) => val == null || val.isEmpty ? 'Required fields' : null,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _stockController,
                hintText: 'Stock',
                keyboardType: TextInputType.number,
                obscureText: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Only digits allowed
                ],
                validator: (val) => val == null || val.isEmpty ? 'Required fields' : null,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _facilitiesController,
                hintText: 'Facilities (separate with commas)',
                obscureText: false,
                validator: (val) => val == null || val.isEmpty ? 'Required fields' : null,
              ),
              const SizedBox(height: 24),
              MyButton(
                onTap: _submitRoom,
                text: _isLoading ? "Save..." : "Add Room",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
