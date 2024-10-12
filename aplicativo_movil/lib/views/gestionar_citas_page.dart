// views/gestionar_citas_page.dart
import 'package:flutter/material.dart';

class GestionarCitasPage extends StatelessWidget {
  const GestionarCitasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Citas'),
      ),
      body: Center(
        child: Text('Aquí puedes gestionar las citas.'),
      ),
    );
  }
}
