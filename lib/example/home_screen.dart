import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:tasko_mobile/common/colors/colors_styles.dart';
import 'package:tasko_mobile/common/core/base_screen.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_disable.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_primary.dart';
import 'package:tasko_mobile/common/widgets/buttons/custom_button_secondary.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  int _counter = 0;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Home Screen'),
      backgroundColor: kColorStylePrimaryNeutralPaletteDarkDefault,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Contador: ', style: TextStyle(fontSize: 20)),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Incrementar'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simulateLoading,
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorStyleWarningDark500,
              ),
              child: const Text(
                'Simular Loading',
                style: TextStyle(color: kColorStyleSecondinaryLightDefault),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simulateError,
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorStyleErrorDark500,
              ),
              child: const Text(
                'Simular Erro',
                style: TextStyle(color: kColorStyleSecondinaryLightDefault),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showSuccessMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorStyleSuccessDark500,
              ),
              child: const Text(
                'Mostrar Sucesso',
                style: TextStyle(color: kColorStyleSecondinaryLightDefault),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtonPrimary(
                label: 'Label Text',
                onPressed: () {},
                leadingIcon: Icons.add,
                trailingIcon: Icons.arrow_forward,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtonSecondary(
                label: 'Label Text',
                onPressed: () {},
                leadingIcon: Icons.add,
                trailingIcon: Icons.arrow_forward,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtonDisable(
                label: 'Label Text',
                onPressed: () {},
                leadingIcon: Icons.add,
                trailingIcon: Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _counter = 0;
        });
        showSnackBar('Contador resetado!');
      },
      child: const Icon(Icons.refresh),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _simulateLoading() async {
    showLoading();
    await Future.delayed(const Duration(seconds: 3));
    hideLoading();
    showSnackBar('Operação concluída!');
  }

  void _simulateError() {
    showError('Ops! Ocorreu um erro na operação.');
  }

  void _showSuccessMessage() {
    showSnackBar('Operação realizada com sucesso!');
  }
}

@Preview(name: 'Home Screen')
Widget homeScreenPreview() {
  return const HomeScreen();
}
