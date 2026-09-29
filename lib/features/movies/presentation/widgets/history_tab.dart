import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../bloc/user_movies_cubit.dart';
import 'user_movies_grid.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: BlocBuilder<UserMoviesCubit, UserMoviesState>(
        buildWhen: (previous, current) =>
            previous.history != current.history ||
            previous.isHistoryLoading != current.isHistoryLoading,
        builder: (context, state) => UserMoviesGrid(
          movies: state.history,
          isLoading: state.isHistoryLoading,
          emptyMessage: AppLocalizations.of(context)!.emptyHistory,
        ),
      ),
    );
  }
}
