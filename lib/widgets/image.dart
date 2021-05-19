import 'package:flutter/material.dart';

// Attempt to fetch remote image for display, without
// throwing an exception if it 404s
class RemoteImage extends StatelessWidget {
  final String url;

  RemoteImage(this.url);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
        return Container();
      },
    );
  }
}