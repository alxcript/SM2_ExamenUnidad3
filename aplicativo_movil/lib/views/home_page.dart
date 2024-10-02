import 'package:flutter/material.dart';
import 'historia_clinica.dart'; // Importa la vista de historia clínica
import '../models/historia_clinica.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoriaClinicaPage(
                  historia: HistoriaClinica(
                    paciente: "Juan Pérez",
                    fecha: "2023-01-15",
                    detalles: "Consulta general",
                  ),
                ),
              ),
            );
          },
          child: const Text('Actualizar Historia Clínica'),
        ),
      ),
    );
  }
}
