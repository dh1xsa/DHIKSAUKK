import 'package:coba1/screen/home/room/order/Payment_Success.dart';
import 'package:coba1/widget/my_button.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:coba1/color.dart';
import 'package:coba1/widget/my_back_button.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  void userTappedPay() async {
    if (formKey.currentState!.validate()) {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('pesanan_hotel')
          .select()
          .order('created_at', ascending: false)
          .limit(1)
          .single();

      if (response != null) {
        final qrString = '''
      Nama: ${response['nama_lengkap']}
      Email: ${response['email']}
      No HP: ${response['no_hp']}
      Kamar: ${response['jenis_kamar']}
      Check-in: ${response['check_in']}
      Check-out: ${response['check_out']}
      Status: ${response['status']}
      ''';

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm payment"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("Card Number: $cardNumber"),
                  Text("Expiry Date: $expiryDate"),
                  Text("Card Holder Name: $cardHolderName"),
                  Text("CVV: $cvvCode"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // tutup dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentSuccessScreen(qrData: qrString),
                    ),
                  );
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        );
      }
    }
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
          "Checkout",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (p0) {},
          ),
          CreditCardForm(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              onCreditCardModelChange: (data) {
                setState(() {
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                });
              },
              formKey: formKey,
          ),
          const SizedBox(height: 129),
          MyButton(
              onTap: userTappedPay,
              text: "Pay Now",
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
