
import 'package:flutter/material.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_validator.dart';
import 'package:movies/utils/firebase_files/auth_function.dart';
import 'package:movies/utils/firebase_files/dialog_utils.dart';
import 'package:movies/widgets/avtar_horizontal_list.dart';
import 'package:movies/widgets/custom_elevatedbutton.dart';
import 'package:movies/widgets/custom_text_field.dart';
import 'package:movies/widgets/language_switch.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/back_app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  

  late TextEditingController emailcontroller;
  late TextEditingController passwordcontroller;
  late TextEditingController namecontroller;
  late TextEditingController confirmpasswordcontroller;
  late TextEditingController phonecontroller;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    namecontroller = TextEditingController();
    confirmpasswordcontroller = TextEditingController();
    phonecontroller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    namecontroller.dispose();
    confirmpasswordcontroller.dispose();
    phonecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
          

    var height = context.height;
   int chosenAvatar=0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: BackAppBar(title: 'Register'),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.03),
            child: Column(
                
              spacing: height*0.01,
              children: [
             /*   Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    Image.asset(height: height * 0.10, AppAssets.avatar8),
                    Image.asset(height: height * 0.15, AppAssets.avatar10),
                    Image.asset(height: height * 0.10, AppAssets.avatar7),
                  ],
                ),*/
                
                

            AvtarHorizontalList(
             onAvatarSelected: (Index) {
                setState(() {
  chosenAvatar =Index; 
});
}
                         ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: height * 0.02,
                  children: [
                    Text(
                      'Avatar',
                      style: TextStyle(color: AppColors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    CustomTextField(
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      controller: namecontroller,
                      hintText: "Name",
                      validator: AppValidator.validateName,
                    ),
                    CustomTextField(
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailcontroller,
                      hintText: "Email",
                      validator: AppValidator.validateEmail,
                    ),
                    CustomTextField(
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      controller: passwordcontroller,
                      hintText: "Password",
                      isPassword: true, 
                      validator: AppValidator.validatePassword,
                    ),
                    CustomTextField(
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      controller: confirmpasswordcontroller,
                      hintText: "Confirm Password",
                      isPassword: true,
                      validator: (value)=>AppValidator.validateConfirmPassword(value,passwordcontroller.text),
                    ),
                    CustomTextField(
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      controller: phonecontroller,
                      hintText: "Phone Number",
                      validator: AppValidator.validatePhone,
                    ),
                    CustomElevatedbutton(
                      text: "Create Account",
                      textStyle: AppStyles.bold20black,
                      navigator: () 
                         async {
                         // print("Start Registration");
               if (formkey.currentState!.validate()) {
  DialogUtils.showLoading( s: 'LOADING...',context);
  try {
     String? error = await FirebaseFunctions.registerUser(
      name: namecontroller.text,
      email: emailcontroller.text,
      password: passwordcontroller.text,
      phone:phonecontroller.text,
      avatar: chosenAvatar, 
    );

   DialogUtils.hideLoading(context);

    if (error == null) {
    
      DialogUtils.showMessage(context, 'Account created successfully!', 
        posActionName: 'Ok', 
        posAction: () {
          Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
        }
      );
    } else {
        
        DialogUtils.showMessage(context, error, title: "Error");
      }
    } catch (e) {
     
      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(context, e.toString(), title: "System Error");
    }
               }         }),       
        
                    

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already Have Account ? ',
                          style: AppStyles.bold14White,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.loginScreen,
                          ),
                          child: Text(
                            'Login',
                            style: AppStyles.bold14White.copyWith(
                              color: AppColors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(child: LanguageSwitch())
                
  
              ],
            ),
         ] ),
        ),
      ),
    ));

  }
 
}
