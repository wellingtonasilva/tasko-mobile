import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';

class AgendaVisitaIconeGroup extends StatelessWidget {
  final IconData icon;

  const AgendaVisitaIconeGroup({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: kColorStyleAgendaVisitaPrimaryLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 25, color: kColorStyleAgendaVisitaPrimary),
        ),
      ),
    );
  }
}
