import 'package:flutter/material.dart';
import '../models/historia_clinica.dart';

class HistoriaClinicaPage extends StatefulWidget {
  final HistoriaClinica historia;

  HistoriaClinicaPage({required this.historia});

  @override
  _HistoriaClinicaPageState createState() => _HistoriaClinicaPageState();
}

class _HistoriaClinicaPageState extends State<HistoriaClinicaPage> {
  late TextEditingController _detallesController;

  @override
  void initState() {
    super.initState();
    _detallesController = TextEditingController(text: widget.historia.detalles);
  }

  void _guardarCambios() {
    print("Cambios guardados: ${_detallesController.text}");
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _detallesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Historia Clínica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _detallesController,
              decoration: InputDecoration(
                labelText: 'Detalles',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
