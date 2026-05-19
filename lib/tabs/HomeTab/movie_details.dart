import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/api/model/movies.dart';
import 'package:movies/home_screen.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';
import 'package:movies/widgets/custom_elevatedbutton.dart';
import 'package:movies/widgets/details_container.dart';
import 'package:movies/widgets/cast_item.dart';
import '../BrowseTab/movies_card.dart';
import 'movie_details_view_model.dart'; 

class MovieDetails extends StatefulWidget {
  final Movies movie;
  const MovieDetails({super.key, required this.movie});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  final MovieDetailsViewModel viewModel = MovieDetailsViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.loadMovieData(widget.movie.id ?? 0);
    viewModel.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildTitleSection(context),
            const SizedBox(height: 15),
            if (viewModel.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (viewModel.errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16)),
                ),
              )
            else
              _buildMainDetails(context), 
          ],
        ),
      ),
    );
  }

  Widget _buildMainDetails(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DetailsContainer(text: viewModel.likeCount, icon: Icons.favorite),
              DetailsContainer(text: viewModel.runtime.toString(), icon: Icons.access_time_filled),
              DetailsContainer(text: viewModel.rating.toString(), icon: Icons.star),
            ],
          ),
          if (viewModel.screenshots.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Screenshots', style: AppStyles.bold22White),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: viewModel.screenshots.length,
              itemBuilder: (context, index) => _buildScreenshotItem(context, viewModel.screenshots[index]),
            ),
          ],
          if (viewModel.suggestions.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text("Similar", style: AppStyles.bold22White),
            const SizedBox(height: 10),
            _buildSuggestionsGrid(),
          ],
          const SizedBox(height: 20),
          Text('Summary', style: AppStyles.bold22White),
          const SizedBox(height: 8),
          Text(
            widget.movie.synopsis ?? widget.movie.descriptionFull ?? 'No description available.', 
            style: AppStyles.medium16white
          ),
          if (viewModel.cast.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Cast', style: AppStyles.bold22White),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: viewModel.cast.length,
              itemBuilder: (context, index) {
                final actor = viewModel.cast[index];
                return CastItem(
                  imageUrl: actor['url_small_image'] ?? '',
                  actorName: actor['name'] ?? '',
                  characterName: actor['character_name'] ?? '',
                );
              },
            ),
          ],
          if (viewModel.genres.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Genres', style: AppStyles.bold22White),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: viewModel.genres.map((genre) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  genre,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              )).toList(),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.movie.backgroundImageOriginal ?? '',
          width: double.infinity,
          height: context.height * 0.60,
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => Container(height: 300, color: Colors.grey[900]),
        ),
        Container(
          height: context.height * 0.60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, AppColors.gray],
            ),
          ),
        ),Positioned.fill(
          top: context.height*.2,
          child: Center(
            child: InkWell(
              onTap: () {},
              child: Image.asset("assets/images/Group 21.png")
            ),
          ),
        ),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.arrow_back_ios, color: AppColors.white), onPressed: () => Navigator.pop(context)),
              IconButton(icon: Icon(Icons.bookmark_rounded, color: AppColors.white), onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          const SizedBox(height: 8),
          Text(widget.movie.title ?? '', style: AppStyles.bold18White, textAlign: TextAlign.center),
          Text(widget.movie.year?.toString() ?? '', style: AppStyles.bold16White, textAlign: TextAlign.center),
          CustomElevatedButton(label: "Watch", onPressed: () {}, backgroundColor: AppColors.red, textStyle: AppStyles.bold20White),
        ],
      ),
    );
  }

  Widget _buildScreenshotItem(BuildContext context, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: double.infinity,
          height: context.height * 0.25,
          errorWidget: (_, _, _) => Container(
            height: 150, 
            color: Colors.grey[900],
            child: const Center(child: Icon(Icons.error, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.suggestions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.70,
      ),
      itemBuilder: (context, index) {
        return MovieCard(
          imageUrl: viewModel.suggestions[index].mediumCoverImage ?? '',
          rating: viewModel.suggestions[index].rating ?? -1,
        );
      },
    );
  }
}