import 'package:flutter/material.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_item.dart';
import 'package:tasko_mobile/common/widgets/stepper/custom_stepper_line.dart';

class CustomStepper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomStepperItem(title: "Cliente", active: true),
        CustomStepperLine(),
        CustomStepperItem(title: "Produtos", active: true),
        CustomStepperLine(),
        CustomStepperItem(title: "Pagamento", active: true),
        CustomStepperLine(),
        CustomStepperItem(title: "Revisão", active: true),
      ],
    );
  }
}
