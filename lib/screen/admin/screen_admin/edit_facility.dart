import 'package:coba1/color.dart';
import 'package:coba1/widget/my_back_button.dart';
import 'package:coba1/widget/my_button.dart';
import 'package:coba1/widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateFacilityScreen extends StatefulWidget {
  final int facilityId; // Assuming `facilityId` is an `int`

  const UpdateFacilityScreen({super.key, required this.facilityId});

  @override
  State<UpdateFacilityScreen> createState() => _UpdateFacilityScreenState();
}

class _UpdateFacilityScreenState extends State<UpdateFacilityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFacilityData();
  }

  Future<void> _loadFacilityData() async {
    try {
      final response = await Supabase.instance.client
          .from('facility')
          .select()
          .eq('id', widget.facilityId) // `facilityId` is now an `int`
          .single();

      if (response != null) {
        _nameController.text = response['name'];
        _descriptionController.text = response['description'];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load facility: $e')),
      );
    }
  }

  Future<void> _updateFacility() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    try {
      final response = await Supabase.instance.client
          .from('facility')
          .update({
        'name': name,
        'description': description,
      })
          .eq('id', widget.facilityId) // `facilityId` is an `int`
          .select();

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facility successfully updated!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update facility: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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
          "Update Facility",
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
                controller: _nameController,
                hintText: 'Name Fasilitas',
                obscureText: false,
                validator: (val) => val == null || val.isEmpty ? 'Required fields' : null,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _descriptionController,
                hintText: 'Description Fasilitas',
                obscureText: false,
                validator: (val) => val == null || val.isEmpty ? 'Required fields' : null,
              ),
              const SizedBox(height: 24),
              MyButton(
                onTap: _updateFacility,
                text: _isLoading ? "Updating..." : "Update Facility",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
