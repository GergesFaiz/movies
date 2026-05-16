import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/tabs/HomeTab/movie_card.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/widgets/movie_list.dart';



class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String searchText = "";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
   
    onTap: () {
      FocusScope.of(context).unfocus(); 
    },
   child:  Scaffold(
     
      body:
       SafeArea(
         child: Column(
           children: [
           
             Padding(
               padding: const EdgeInsets.all(16),
               child: TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                cursorColor: AppColors.white,
                 style: AppStyles.bold18White, 
                 decoration: InputDecoration(
                   hintText: "Search ",
                   hintStyle: AppStyles.bold18White,
                   
                  
                   prefixIcon:
                   Padding( padding:const EdgeInsets.all(12),
                   child: 
                   SvgPicture.asset(
                    AppIcon.search,
                    width: 20,
                    height: 20,
                   )
                   ),
                   // const Icon(Icons.search_rounded, color: AppColors.white), 
                   filled: true,
                   fillColor: AppColors.gray.withOpacity(0.2), 
                   disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide.none
                   ),
                   contentPadding: const EdgeInsets.symmetric(vertical: 15),
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(15),
                     borderSide: BorderSide.none, 
                        
                   ),
                   enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
               borderSide: BorderSide.none,
                   ),
                   focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
               borderSide: BorderSide.none,
                   )
                 
                 ),
                 onChanged: (value) {
                  setState(() {
                            searchText = value; 
                          });
                 },
               ),
             ),
           Expanded(
             child: searchText.isEmpty 
                     ? Center(child: Image.asset(AppAssets.empty1))  
                     : GridView.builder(
          padding: const EdgeInsets.all(16),
        
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15, 
            mainAxisSpacing: 15, 
            childAspectRatio: 0.7, 
          ),
          itemCount: moviesList.length,
          itemBuilder: (context, index) {
            return MovieCard(
              image: moviesList[index].image,
              text: moviesList[index].rating.toString(),
            );
          },
        )
           )
           ],
         ),
       ),
       
    ));
  }
}