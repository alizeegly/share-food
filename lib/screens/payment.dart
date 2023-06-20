import 'package:flutter/material.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/screens/payment_confirm.dart';
import 'package:sharefood/widgets/custom_date_time_field.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.storage});

  final CartStorage storage;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

Future<List<Product>> fetchCart(List<String> productIds) async {
  List<Product> products = [];

  for(final productId in productIds) {
    DocumentSnapshot<Map<String, dynamic>> productSnapshot = 
      await FirebaseFirestore.instance.collection('products').doc(productId).get();

    DocumentSnapshot<Map<String, dynamic>> sellerSnapshot = 
      await productSnapshot["seller"].get();

    Product product = Product(
      productSnapshot.reference.id,
      productSnapshot['name'],
      productSnapshot['pictureUrl'],
      productSnapshot['type'],
      productSnapshot['price'],
      UserModel(firstname: sellerSnapshot["firstname"], lastname: sellerSnapshot["lastname"], address: sellerSnapshot["address"], email: sellerSnapshot["email"], city: sellerSnapshot["city"], zipcode: sellerSnapshot["zipcode"], status: sellerSnapshot["status"], lat: sellerSnapshot["lat"], lng: sellerSnapshot["lng"], password: sellerSnapshot["password"], avatarUrl: sellerSnapshot["avatarUrl"], createdAt: sellerSnapshot["createdAt"])
    );

    products.add(product);
  }

  return products;
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<String> _productIds = [];
  Future<List<Product>>? futureCartScreen;

  @override
  void initState() {
    _dateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [HH, ':', nn]).toString();

    super.initState();

    widget.storage.readCart().then((value) {
      setState(() {
        _productIds = value;
        futureCartScreen = fetchCart(_productIds);
      });
    });
  }

  // Datetime picker
  String? _setTime, _setDate;
  late String _hour, _minute, _time;
  late String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 12, minute: 00);

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

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar:
          AppBar(title: const Text("Paiement"), centerTitle: false, backgroundColor: colors.secondary, foregroundColor: colors.onSecondary),
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
                            // TODO Créer la commande

                            // Vider le panier
                            widget.storage.writeCart([]);

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
