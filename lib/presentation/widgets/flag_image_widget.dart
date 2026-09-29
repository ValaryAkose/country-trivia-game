import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FlagImageWidget extends StatelessWidget {
  final String flagUrl;
  final double width;
  final double height;

  const FlagImageWidget({
    super.key,
    required this.flagUrl,
    this.width = 200,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: flagUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text('Failed to load flag', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
