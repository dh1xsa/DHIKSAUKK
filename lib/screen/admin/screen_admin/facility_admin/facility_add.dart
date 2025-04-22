import 'package:coba1/color.dart';
import 'package:coba1/widget/my_back_button.dart';
import 'package:coba1/widget/my_button.dart';
import 'package:coba1/widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddFacilityScreen extends StatefulWidget {
  const AddFacilityScreen({super.key});

  @override
  State<AddFacilityScreen> createState() => _AddFacilityScreenState();
}

class _AddFacilityScreenState extends State<AddFacilityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submitFacility() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    try {
      final response = await Supabase.instance.client
          .from('facility')
          .insert({
        'name': name,
        'description': description,
      })
          .select();

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facility successfully added!')),
        );
        Navigator.pop(context);
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add facility: $e')),
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
          "Facility",
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
                maxLines: 5,
                validator: (val) => val == null || val.isEmpty ? 'Required fields' : null,
              ),
              const SizedBox(height: 24),
              MyButton(
                onTap: _submitFacility,
                text: _isLoading ? "Save..." : "Add Facility",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
