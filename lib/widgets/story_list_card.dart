import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoryListCard extends StatelessWidget {
  final String title;
  final String description;
  final String thumbnail;
  final Function onPress;

  const StoryListCard({
    super.key,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress.call(),
      child: Card(
        elevation: 2.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: thumbnail,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                ),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    description,
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 4,
            ),
          ],
        ),
      ),
    );
  }
}
