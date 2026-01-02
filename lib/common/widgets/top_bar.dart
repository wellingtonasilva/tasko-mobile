import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color.fromRGBO(46, 49, 57, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color.fromRGBO(255, 115, 29, 100),
            child: const SizedBox(height: 7, width: 48),
          ),
          const Image(
            image: AssetImage('assets/images/pos_logo.png'),
            height: 40,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

@Preview(name: 'Top Bar Preview')
Widget topBarPreview() {
  return const Padding(padding: EdgeInsets.all(16.0), child: TopBar());
}
