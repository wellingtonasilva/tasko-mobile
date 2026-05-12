import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';

class AgendaVisitaContainerGroup extends StatelessWidget {
  final List<Widget> children;

  const AgendaVisitaContainerGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kColorStyleAgendaVisitaSurface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(children: children),
    );
  }
}
