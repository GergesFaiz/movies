import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CastItem extends StatelessWidget {
  final String? imageUrl;
  final String? actorName;
  final String? characterName;

  const CastItem({
    super.key,
    required this.imageUrl,
    required this.actorName,
    required this.characterName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final actor = actorName ?? '';
    final character = characterName ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => Container(
                width: 60,
                height: 60,
                color: Colors.grey[800],
                child: Icon(Icons.person, color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.actorName(actor.isEmpty ? l10n.unknown : actor),
                  style:  AppStyles.bold16White, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.characterName(
                    character.isEmpty ? l10n.unknown : character,
                  ),
                   style:  AppStyles.bold16White, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}