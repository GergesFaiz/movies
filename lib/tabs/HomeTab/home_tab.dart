import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies/tabs/HomeTab/movie_card.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';
import 'package:movies/widgets/movie_list.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    double width=context.width;
    double height=context.height;
    return Scaffold(
     
      body: Stack(
          fit: StackFit.expand,
          children: [
            
            
               SizedBox(
                      height: context.height * 0.5, 
      
                      width: width,
                      child: Image.asset(
                        AppOnboardingImage.onbaordingImage6,
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                      height: context.height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent, 
                AppColors.gray.withOpacity(0.8),
                AppColors.gray, 
              ],
              stops: const [0.0, 0.4, 0.9], 
                        ),
                      ),
              ),
             
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                 // spacing: context.height/2.5,
                  children: [
                    SafeArea(
                      child: 
                    Image.asset(AppAssets.available),),
                     /* SizedBox(
                       /// height: 250,
                       height: height * 0.35,
                        child: ListView.builder( 
                          scrollDirection: Axis.horizontal,
                          itemCount: moviesList.length,
                          itemBuilder: (context, index) {
                            return  MovieCard(image: moviesList[index].image, 
                            text: moviesList[index].rating.toString())
                            ;
                          },),
                      ),*/
                      CarouselSlider.builder(
  itemCount: moviesList.length,
  itemBuilder: (context, index, realIndex) {
    return MovieCard(
      image: moviesList[index].image,
      text: moviesList[index].rating.toString(),
    );
  },
  options: CarouselOptions(
    height: height * 0.5, 
    enlargeCenterPage: true, 
    autoPlay: false, 
    aspectRatio: 16/ 9,
    autoPlayCurve: Curves.fastOutSlowIn,
    enableInfiniteScroll: true,
    viewportFraction: 0.7, 
    enlargeFactor: 0.3
    
  ),
),
                               Image.asset(AppAssets.watchnow),
                               Padding(
                                 padding: const EdgeInsets.symmetric(horizontal: 10),
                                 child: Row(
                                  
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Action",style: AppStyles.bold18White,),
                                    TextButton.icon(onPressed: (){},
                                     label:Text('See More',style: AppStyles.medium15Amber,) ,
                                     icon: Icon(Icons.arrow_forward,color: AppColors.amber,),
                                     iconAlignment: IconAlignment.end,
                                     ),
                                       ],
                                 ),
                               ),
                                       SizedBox(
                                       // height: 250,
                                       height: height * 0.3,
                                      // width: width*.3,
                                         child: ListView.builder( 
                                                                 scrollDirection: Axis.horizontal,
                                                                 itemCount: moviesList.length,
                                                                 itemBuilder: (context, index) {
                                                                   return  AspectRatio(
                                                                    aspectRatio: 2/3,
                                                                     child: MovieCard(image: moviesList[index].image, 
                                                                     text: moviesList[index].rating.toString()),
                                                                   )
                                                                   ;
                                                                 },),
                                       ),
      
                              
                  ],
                ),
              ),
                      
                      
              ],
            
          
      )
    );
  }
}