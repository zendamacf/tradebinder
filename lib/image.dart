import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';

// Attempt to fetch remote image for display, without
// throwing an exception if it 404s
class RemoteImage extends StatelessWidget {
  final String url;

  RemoteImage(this.url);

  @override
  Widget build(BuildContext context) {
    return new Image(image: new NetworkImageWithRetry(
      this.url,
      fetchStrategy: new FetchStrategyBuilder(maxAttempts: 1).build(),
    ));
  }
}