import 'package:flutter/material.dart';
import 'package:movies/utils/app_assets.dart';


class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body:
       Column(
         children: [
          TextFormField(
            
          ),
           Center(child: 
                 Image.asset(AppAssets.empty1)
                 ),
         ],
       ),
    );
  }
}