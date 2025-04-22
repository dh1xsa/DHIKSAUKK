import 'package:coba1/color.dart';
import 'package:coba1/widget/my_button.dart';
import 'package:coba1/widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:coba1/widget/custom_appbar.dart';
import 'package:coba1/screen/admin/widget_admin/drawer_admin.dart';

class EditRoomScreen extends StatefulWidget {
  final int roomId;
  const EditRoomScreen({super.key, required this.roomId});

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _facilitiesController = TextEditingController();

  bool _isLoading = false;

  Future<void> _loadRoomData() async {
    try {
      final response = await Supabase.instance.client
          .from('rooms')
          .select()
          .eq('id', widget.roomId)
          .single();

      if (response != null) {
        _typeController.text = response['type'];
        _priceController.text = response['price'].toString();
        _stockController.text = response['stock'].toString();
        _facilitiesController.text = response['facilities'];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data kamar: $e')),
      );
    }
  }

  Future<void> _submitRoom() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final type = _typeController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    final facilities = _facilitiesController.text.trim();

    try {
      final response = await Supabase.instance.client
          .from('rooms')
          .update({
        'type': type,
        'price': price,
        'stock': stock,
        'facilities': facilities,
      })
          .eq('id', widget.roomId)
          .select();

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kamar berhasil diperbarui!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui kamar: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRoomData(); 
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
      appBar: CustomAppBar(),
      drawer: MyDrawerAdmin(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 25),
              MyTextField(
                controller: _typeController,
                hintText: 'Tipe Kamar',
                obscureText: false,
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _priceController,
                hintText: 'Harga per malam',
                keyboardType: TextInputType.number,
                obscureText: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _stockController,
                hintText: 'Stok Kamar',
                keyboardType: TextInputType.number,
                obscureText: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _facilitiesController,
                hintText: 'Fasilitas (pisahkan dengan koma)',
                obscureText: false,
                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              MyButton(
                onTap: _submitRoom,
                text: _isLoading ? "Menyimpan..." : "Perbarui Kamar",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
