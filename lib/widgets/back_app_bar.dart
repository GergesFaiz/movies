import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget{
  String title;
   BackAppBar({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back,color: AppColors.amber,),onPressed: () => Navigator.pop(context),),
      elevation: 0,
      title: Text(
        title,
        style: AppStyles.bold16White.copyWith(color: AppColors.amber),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.white),
    );
  }

  @override
  // TODO: implement preferredSize
  @override Size get preferredSize => const Size.fromHeight(56);
}
