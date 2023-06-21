import 'package:flutter/material.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/repository/authentication_repository/auth_repository.dart';
import 'package:sharefood/screens/profile/orders/purchases.dart';
import 'package:sharefood/screens/profile/update_profile_screen.dart';
import 'package:sharefood/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:sharefood/controllers/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres"), centerTitle: false, backgroundColor: colors.secondary, foregroundColor: colors.onSecondary),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  UserModel user = snapshot.data as UserModel;

                  return Column(
                    children: [
                      SizedBox(
                        width: 120, height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(user.avatarUrl, fit: BoxFit.cover)
                        )
                      ),
                      const SizedBox(height: 17),
                      Text(
                        "${user.firstname} ${user.lastname}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfileScreen()));
                        },
                        color: Theme.of(context).primaryColor,
                        text: "Modifier mon profil",
                      ),
                
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 30),
                
                      ProfileMenuWidget(
                        title: "Paramètres",
                        icon: Icons.settings_outlined,
                        onPressed: () {},
                      ),
                      ProfileMenuWidget(
                        title: "Gérer mes produits",
                        icon: Icons.shopping_cart_outlined,
                        onPressed: () {},
                      ),
                      ProfileMenuWidget(
                        title: "Consulter mes achats",
                        icon: Icons.wallet_outlined,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PurchasesScreen()));
                        },
                      ),
                      ProfileMenuWidget(
                        title: "Consulter mes ventes",
                        icon: Icons.sell,
                        onPressed: () {},
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      ProfileMenuWidget(
                        title: "Se déconnecter",
                        icon: Icons.logout,
                        textColor: Colors.red,
                        endIcon: false,
                        onPressed: () {
                          AuthRepository.instance.logout();
                        },
                      ),
                    ]
                  );
                } else if(snapshot.hasError){
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),
        )
      )
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.endIcon = true,
    this.textColor
  });

  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool endIcon;
  final Color? textColor; 

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1)
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.secondary)
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium?.apply(color: textColor)),
      trailing: endIcon ? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1)
        ),
        child: const Icon(Icons.arrow_forward_ios_rounded, size: 18.0, color: Colors.grey),
      ) : null,
    );
  }
}