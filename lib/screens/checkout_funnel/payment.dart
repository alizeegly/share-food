import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharefood/controllers/profile_controller.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/screens/checkout_funnel/payment_confirm.dart';
import 'package:sharefood/widgets/custom_appbar.dart';
import 'package:sharefood/widgets/form_fields/custom_date_time_field.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.storage});

  final CartStorage storage;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<List<Product>>? futureCartScreen;

  @override
  void initState() {
    _dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [HH, ':', nn]).toString();

    super.initState();

    setState(() {
      futureCartScreen = widget.storage.readCart();
    });
  }

  // Datetime picker
  String? _setTime, _setDate;
  late String _hour, _minute, _time;
  late String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      locale: const Locale('fr', 'FR')
    );
    if (picked != null){
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat("dd/MM/yyyy").format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [HH, ':', nn]).toString();
      });
    }
  }

  void createOrder(AsyncSnapshot<List<Product>> snapshot) async {
    // Créer l'objet json
    final controller = Get.put(ProfileController());
    UserModel user = await controller.getUserData();
    var order = {
      "seller": FirebaseFirestore.instance.doc("sellers/${snapshot.data![0].seller.id}"),
      "buyer": FirebaseFirestore.instance.doc("sellers/${user.id}"),
      "createdAt": Timestamp.now(),
      "appointment": Timestamp.fromDate(DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute))
    };

    // Créer la commande dans Firestore et récupérer son id
    DocumentReference<Map<String, dynamic>> newOrdersnapshot = await FirebaseFirestore.instance.collection("orders").add(order);
    String orderId = newOrdersnapshot.id;

    // Ajouter la commande à tous les produits du panier
    for (var product in snapshot.data!) {
      FirebaseFirestore.instance.collection("products").doc(product.id).update({"order": FirebaseFirestore.instance.doc("orders/$orderId")});
    }

    // Vider le panier
    widget.storage.writeCart([]);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(text: "Paiement"),
      body: ListView(
        children: [FutureBuilder<List<Product>>(
          future: futureCartScreen,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    boxShadow: [BoxShadow(
                      color: colors.shadow,
                      spreadRadius: 0,
                      blurRadius: 40,
                      offset: const Offset(0, 40)
                    )]
                  ),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Text("Vous paierez directement le vendeur par espèces", style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center,),
      
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Localisation :", style: Theme.of(context).textTheme.titleSmall),
                                    Text(snapshot.data![0].seller.address, style: Theme.of(context).textTheme.bodySmall),
                                    Text("${snapshot.data![0].seller.zipcode} - ${snapshot.data![0].seller.city}", style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                              ),
      
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Date et heure de rendez-vous :", style: Theme.of(context).textTheme.titleSmall),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _selectDate(context);
                                            },
                                            child: CustomDateTimeField(
                                              controller: _dateController,
                                              setState: _setDate,
                                              hintText: "Date",
                                              isObsecre: false,
                                            )
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              _selectTime(context);
                                            },
                                            child: CustomDateTimeField(
                                              controller: _timeController,
                                              setState: _setTime,
                                              hintText: "Heure",
                                              isObsecre: false,
                                            )
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
      
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Total à régler :", style: Theme.of(context).textTheme.titleSmall),
                                    Text('${snapshot.data!.fold(0.0, (previousValue, element) => previousValue + element.price).toStringAsFixed(2)}€', style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
      
                        ElevatedButton(
                          onPressed: () {
                            createOrder(snapshot);

                            // Ecran de confirmation
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const PaymentConfirmScreen()), (Route<dynamic> route) => false);
                          },
                          style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: colors.primary, padding: const EdgeInsets.symmetric(horizontal: 40)),
                          child: Text("Valider", style: TextStyle(fontSize: Theme.of(context).textTheme.labelLarge?.fontSize, color: colors.onPrimary), textAlign: TextAlign.center)
                        )
                    ]
                  )
                );
              }
              else {
                return const Text("Le panier est vide");
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
      
            // By default, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          },
        )]
      )
    );
  }
}
