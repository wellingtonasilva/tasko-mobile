import 'package:flutter/material.dart';
import 'package:tasko_mobile/domain/vendedor/response/vendedor_response.dart';

class VendedorManterControllers {
  final formKey = GlobalKey<FormState>();
  late final PageController pageController;

  VendedorManterControllers() {
    pageController = PageController();
  }

  void dispose() {
    pageController.dispose();
  }

  void updateFormFields(VendedorResponse vendedor) {
    //id.controller.text = vendedor.id.toString();
    //codigoVendedor.controller.text = vendedor.codigoVendedor ?? '';
    //nomeVendedor.controller.text = vendedor.nomeVendedor ?? '';
    //numeroCPF.controller.text = vendedor.numeroCPF ?? '';
    //email.controller.text = vendedor.email ?? '';
    //numeroTelefone.controller.text = vendedor.numeroTelefone ?? '';
    //valorMetaMensal.controller.text =
    //    vendedor.valorMetaMensal?.toStringAsFixed(2) ?? '';
    //percentualComissao.controller.text =
    //    vendedor.percentualComissao?.toStringAsFixed(2) ?? '';
    //ultimoSincronismo.controller.text =
    //    vendedor.ultimoSincronismo?.toIso8601String() ?? '';
    //codigoDispositivo.controller.text = vendedor.codigoDispositivo ?? '';
  }
}
