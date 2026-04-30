import 'package:flutter/material.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';

class CustomTextField  extends StatefulWidget
 {
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool ispassword;
  final String hinttext;
  

  const CustomTextField({super.key,required this.textInputType, 
  required this.textInputAction,
   required this.controller,
    this.validator, 
   this.ispassword=false,
    required this.hinttext});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isShowPassword  ;
  @override
  void initState() {
    super.initState();
    
    isShowPassword = widget.ispassword;
  }
  @override
  Widget build(BuildContext context) {
   return TextFormField(
    autocorrect: false,
    enableSuggestions: false,
    cursorColor: AppColors.white,
    cursorRadius: Radius.circular(16),
    keyboardType:widget.ispassword 
    ? widget.textInputType 
    : TextInputType.visiblePassword, 
    textInputAction: widget.textInputAction,
    controller:widget.controller ,
    validator:widget.validator ,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    style:  AppStyles.regular16white,
    obscureText: isShowPassword,
    onTapOutside: (_) =>FocusManager.instance.primaryFocus?.unfocus() ,
    decoration: InputDecoration(
   hintText: widget.hinttext,
   hintStyle:    AppStyles.regular16white,
   
   

   filled: true,
   fillColor: AppColors.gray,
   suffixIcon:widget.ispassword?
    IconButton(onPressed: (){
      setState(() {
        isShowPassword= !isShowPassword;
      });
    }, icon: Icon(
      isShowPassword?Icons.visibility_off:
      Icons.visibility,color: AppColors.white,)):null
    ,
    prefixIcon:widget.ispassword?
    Icon(Icons.lock,color: AppColors.white)
     :Icon( Icons.email,color: AppColors.white,),
   border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15)
   ),
   enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
     borderSide: BorderSide(color: AppColors.blackColor,width: 1)
   ),
   focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
     borderSide: BorderSide(color: AppColors.blackColor,width: 1)
   ),
   errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: AppColors.primary,width: 1)
   ),
    ),
   )
   ;
  }
}