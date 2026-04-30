 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/utils/app_colors.dart';


class CustomDivider extends StatelessWidget 
  {
  const CustomDivider({super.key});

   
 


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:90 ),
      child: Row(
        children: [
      
      Expanded(
        child: Divider(
          thickness: 1, 
          color: AppColors.amber,
          endIndent: 10,
        ),
      ),
      
      Text(
        "OR",
        style:GoogleFonts.roboto(
       fontSize: 15,
       fontWeight: FontWeight.w400,
       color: AppColors.amber
       
      ),
      ),
      
      Expanded(
        child: Divider(
          thickness: 1,
          color:AppColors.amber,
          indent: 10, 
        ),
      ),]),
    )
   ;
  }}