import 'package:flutter/material.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';


class MovieCard  extends StatelessWidget
{  final String image;
   final String text;
  const MovieCard({super.key,required this.image, required this.text});
  @override
  Widget build(BuildContext context) {
   double width=context.width;
    double height=context.height;
   return
   Container(
   width: width, 
    height: height,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children:[
           ClipRRect(
           borderRadius: BorderRadius.circular(16),
            child:Image.asset(image,fit: BoxFit.cover,),

          
        ),
        Positioned(
          top:10 ,
          left:10 ,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text(text,
                  style: AppStyles.regular16white,
                  )
                ],
              ),
          )
        )
        ]
      ),
      )
   ;
  }}