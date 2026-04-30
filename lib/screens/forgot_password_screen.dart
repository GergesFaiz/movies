import 'package:flutter/material.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/widgets/back_app_bar.dart';

import '../../utils/app_styles.dart';
import '../widgets/primary_button_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool emailSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(title: "Forget Password"),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 430,
                child: Center(child: Image.asset(AppAssets.forgotPasswordBro)),
              ),
              TextField(
                controller: emailController,
                style: AppStyles.medium16white,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: AppStyles.medium16white,
                  prefixIcon: ImageIcon(
                    AssetImage(AppAssets.emailIcon),
                    size: 31,
                    color: AppColors.white,
                  ),
                  filled: true,
                  fillColor: AppColors.gray.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.gray),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              PrimaryButtonWidget(label: "Verify Email", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

//
// import 'package:flutter/material.dart';
//
// class ForgotPasswordScreen extends StatefulWidget {
//    ForgotPasswordScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
// }
//
// class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final TextEditingController emailController = TextEditingController();
//
//   void verifyEmail() {
//     final email = emailController.text.trim();
//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//          SnackBar(content: Text("Please enter your email")),
//       );
//     } else {
//       // TODO: Add your reset password logic here (API call / Firebase)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Verification link sent to $email")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:  Text("Forget Password"),
//         leading: IconButton(
//           icon:  Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding:  EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//              SizedBox(height: 40),
//             // Illustration placeholder
//             SizedBox(
//               height: 200,
//               child: Center(
//                 child: Icon(Icons.lock_reset, size: 100, color: Colors.amber),
//               ),
//             ),
//              SizedBox(height: 30),
//             TextField(
//               controller: emailController,
//               decoration:  InputDecoration(
//                 labelText: "Email",
//                 prefixIcon: Icon(Icons.email),
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//              SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: verifyEmail,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.amber,
//                 minimumSize:  Size(double.infinity, 50),
//               ),
//               child:  Text("Verify Email"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
