import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TargetsScreen extends StatefulWidget {
  final String userId;
  const TargetsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _TargetsScreenState createState() => _TargetsScreenState();
}

class _TargetsScreenState extends State<TargetsScreen> {
  List<Objectif> _objectifs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchObjectifs();
  }

  Future<void> _fetchObjectifs() async {
    setState(() => _loading = true);
    final url = Uri.parse(
      'http://localhost:8080/api/objectifs/user/${widget.userId}',
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      setState(() {
        _objectifs = data.map((json) => Objectif.fromJson(json)).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de récupération: ${res.statusCode}')),
      );
    }
    setState(() => _loading = false);
  }

  Future<void> _createObjectif(Objectif obj) async {
    final url = Uri.parse('http://localhost:8080/api/objectifs');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(obj.toJson()),
    );
    if (res.statusCode == 201) {
      Navigator.of(context).pop();
      _fetchObjectifs();
    } else {
      final error = json.decode(res.body)['error'];
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $error')));
    }
  }

  Future<void> _deleteObjectif(String id) async {
    final url = Uri.parse('http://localhost:8080/api/objectifs/$id');
    final res = await http.delete(url);
    if (res.statusCode == 200) {
      _fetchObjectifs();
    } else {
      final error = json.decode(res.body)['error'];
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $error')));
    }
  }

  Future<void> _updateObjectif(String id, Objectif updated) async {
    final url = Uri.parse('http://localhost:8080/api/objectifs/$id');
    final res = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updated.toJson()),
    );
    if (res.statusCode == 200) {
      Navigator.of(context).pop();
      _fetchObjectifs();
    } else {
      final error = json.decode(res.body)['error'];
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: $error')));
    }
  }

  void _showAddDialog() {
    _showFormDialog();
  }

  void _showEditDialog(Objectif obj) {
    _showFormDialog(existing: obj);
  }

  void _showFormDialog({Objectif? existing}) {
    final _formKey = GlobalKey<FormState>();
    String? _type = existing?.typeObj;
    final _poidsCtrl = TextEditingController(
      text: existing?.poidsCible.toString(),
    );
    final _calCtrl = TextEditingController(
      text: existing?.caloriesTotal.toString(),
    );
    DateTime? _endDate = existing?.dateFin;

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              existing == null ? 'Nouvel Objectif' : 'Modifier Objectif',
            ),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _type,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: const [
                        DropdownMenuItem(
                          value: 'PERTE_POIDS',
                          child: Text('Perte de poids'),
                        ),
                        DropdownMenuItem(
                          value: 'MAINTIEN_POIDS',
                          child: Text('Maintien de poids'),
                        ),
                        DropdownMenuItem(
                          value: 'PRISE_POIDS',
                          child: Text('Prise de poids'),
                        ),
                      ],
                      onChanged: (v) => _type = v,
                      validator:
                          (v) => v == null ? 'Sélectionnez un type' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Poids cible (kg)',
                      ),
                      controller: _poidsCtrl,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator:
                          (v) =>
                              (v == null ||
                                      double.tryParse(v) == null ||
                                      double.parse(v) <= 0)
                                  ? 'Entrez un poids valide'
                                  : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Calories totales',
                      ),
                      controller: _calCtrl,
                      keyboardType: TextInputType.number,
                      validator:
                          (v) =>
                              (v == null ||
                                      int.tryParse(v) == null ||
                                      int.parse(v) <= 0)
                                  ? 'Entrez un nombre de calories'
                                  : null,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _endDate == null
                                ? 'Date de fin non sélectionnée'
                                : 'Fin: ${_endDate?.toLocal().toIso8601String().split('T').first}',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate:
                                  existing?.dateFin ??
                                  DateTime.now().add(const Duration(days: 1)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) {
                              setState(() => _endDate = picked);
                            }
                          },
                          child: const Text('Sélectionner'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate() || _endDate == null)
                    return;
                  final obj = Objectif(
                    idObj: existing?.idObj,
                    typeObj: _type!,
                    poidsCible: double.parse(_poidsCtrl.text),
                    caloriesTotal: int.parse(_calCtrl.text),
                    dateDebut: existing?.dateDebut ?? DateTime.now(),
                    dateFin: _endDate!,
                    userId: widget.userId,
                  );
                  if (existing == null) {
                    _createObjectif(obj);
                  } else {
                    _updateObjectif(existing.idObj!, obj);
                  }
                },
                child: Text(existing == null ? 'Créer' : 'Enregistrer'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Targets'),
        backgroundColor: Colors.green,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _showAddDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Nouvel Objectif'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        _objectifs.isEmpty
                            ? const Center(
                              child: Text('Aucun objectif défini.'),
                            )
                            : ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: _objectifs.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 12),
                              itemBuilder: (ctx, i) {
                                final o = _objectifs[i];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 3,
                                  child: ListTile(
                                    title: Text(o.typeLabel),
                                    subtitle: Text(
                                      'Poids: ${o.poidsCible} kg\nCalories: ${o.caloriesTotal}\nDu ${o.dateDebutStr} au ${o.dateFinStr}',
                                    ),
                                    isThreeLine: true,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => _showEditDialog(o),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed:
                                              () => _deleteObjectif(o.idObj!),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}

class Objectif {
  final String? idObj;
  final String typeObj;
  final double poidsCible;
  final int caloriesTotal;
  final DateTime dateDebut;
  final DateTime dateFin;
  final String userId;

  Objectif({
    this.idObj,
    required this.typeObj,
    required this.poidsCible,
    required this.caloriesTotal,
    required this.dateDebut,
    required this.dateFin,
    required this.userId,
  });

  factory Objectif.fromJson(Map<String, dynamic> json) => Objectif(
    idObj: json['idObj'],
    typeObj: json['typeObj'],
    poidsCible: (json['poidsCible'] as num).toDouble(),
    caloriesTotal: json['caloriesTotal'],
    dateDebut: DateTime.parse(json['dateDebut']),
    dateFin: DateTime.parse(json['dateFin']),
    userId: json['userId'],
  );

  Map<String, dynamic> toJson() => {
    'typeObj': typeObj,
    'poidsCible': poidsCible,
    'caloriesTotal': caloriesTotal,
    'dateDebut': dateDebut.toIso8601String(),
    'dateFin': dateFin.toIso8601String(),
    'userId': userId,
  };

  String get typeLabel {
    switch (typeObj) {
      case 'PERTE_POIDS':
        return 'Perte de poids';
      case 'MAINTIEN_POIDS':
        return 'Maintien de poids';
      case 'PRISE_POIDS':
        return 'Prise de poids';
      default:
        return typeObj;
    }
  }

  String get dateDebutStr =>
      dateDebut.toLocal().toIso8601String().split('T').first;
  String get dateFinStr => dateFin.toLocal().toIso8601String().split('T').first;
}
