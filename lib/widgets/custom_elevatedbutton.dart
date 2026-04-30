import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';

class CustomElevatedbutton  extends StatelessWidget
{ 
final  String text ;
  final bool isIcon;

 const CustomElevatedbutton({super.key,required this.text,this.isIcon=false});
  
  @override
  Widget build(BuildContext context) {
  return ElevatedButton(onPressed: (){},
 style:  ElevatedButton.styleFrom(
  backgroundColor: AppColors.amber,
  padding: EdgeInsets.all(15),
shape: RoundedRectangleBorder(
  borderRadius: BorderRadiusGeometry.circular(15)
),
alignment: Alignment.center

 ),
   child: isIcon?
   
   Row(
    mainAxisAlignment: MainAxisAlignment.center,
    spacing: 5,
     children: [
       //Icon(,color: AppColors.gray,size: 40,),
         SvgPicture.asset(AppIcon.googleIcon,
         height: 24,
         width: 24,),
       
       Text(text,style:  GoogleFonts.roboto(
 fontSize: 16,
 fontWeight: FontWeight.w400,
 color: AppColors.gray
 ),)
     ],
   )
   :
  Text(text,style:  GoogleFonts.roboto(
 fontSize: 20,
 fontWeight: FontWeight.w400,
 color: AppColors.gray
 ),))
  ;
  }}