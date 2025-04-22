import 'package:coba1/color.dart';
import 'package:coba1/screen/resepsionis/widget/card_order.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResepsionisScreen extends StatefulWidget {
  const ResepsionisScreen({super.key});

  @override
  State<ResepsionisScreen> createState() => _ResepsionisScreenState();
}

class _ResepsionisScreenState extends State<ResepsionisScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<dynamic> pesanan = [];
  bool isLoading = true;
  bool isUpdating = false;

  final List<String> statusOptions = ['pending', 'success', 'cancelled', 'done'];

  @override
  void initState() {
    super.initState();
    fetchPesanan();
  }

  Future<void> fetchPesanan() async {
    setState(() => isLoading = true);
    try {
      final response = await supabase
          .from('pesanan_hotel')
          .select()
          .order('created_at', ascending: false);
      setState(() => pesanan = response);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> updateStatus(String id, String newStatus) async {
    setState(() => isUpdating = true);
    try {
      await supabase
          .from('pesanan_hotel')
          .update({'status': newStatus})
          .eq('id', id);
      await fetchPesanan();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status: $e')),
      );
    } finally {
      setState(() => isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: _buildAppBar(context),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : pesanan.isEmpty
              ? const Center(child: Text("There is no pesanan data yet."))
              : RefreshIndicator(
            onRefresh: fetchPesanan,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: pesanan.length,
              itemBuilder: (context, index) {
                final item = pesanan[index];
                return OrderCard(
                  data: item,
                  statusOptions: statusOptions,
                  onStatusChanged: (newStatus) {
                    updateStatus(item['id'], newStatus);
                  },
                );
              },
            ),
          ),
        ),
        if (isUpdating)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
        "Pesanan Hotel",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}
