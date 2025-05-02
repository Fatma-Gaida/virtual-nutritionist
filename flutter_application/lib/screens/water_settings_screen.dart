import 'package:flutter/material.dart';

class WaterSettingsScreen extends StatefulWidget {
  const WaterSettingsScreen({super.key});

  @override
  State<WaterSettingsScreen> createState() => _WaterSettingsScreenState();
}

class _WaterSettingsScreenState extends State<WaterSettingsScreen> {
  bool reminderEnabled = true;
  int startHour = 8;
  int startMinute = 0;
  int reminderCount = 8;
  int intervalMinutes = 90;
  int waterGoal = 2000;
  bool autoCalculate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Paramètre', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reminder Settings
              const Text(
                'rappel de boire de l\'eau',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'définir l\'heure de rappel',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              // Enable reminder switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // Empty space for alignment
                  Switch(
                    value: reminderEnabled,
                    onChanged: (value) {
                      setState(() {
                        reminderEnabled = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Start time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Heure de départ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _showTimePickerDialog(true),
                        child: _buildTimeBox(startHour),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _showTimePickerDialog(false),
                        child: _buildTimeBox(startMinute),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Reminder count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Horaires de rappel',
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap:
                            () => _showNumberPickerDialog(
                              'Horaires de rappel',
                              1,
                              20,
                              reminderCount,
                              (value) {
                                setState(() {
                                  reminderCount = value;
                                });
                              },
                            ),
                        child: _buildCountBox(reminderCount),
                      ),
                      const SizedBox(width: 8),
                      const Text('Fois', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Interval time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Temps d\'interval',
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap:
                            () => _showNumberPickerDialog(
                              'Temps d\'interval',
                              15,
                              240,
                              intervalMinutes,
                              (value) {
                                setState(() {
                                  intervalMinutes = value;
                                });
                              },
                            ),
                        child: _buildCountBox(intervalMinutes),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Minutes',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // App invite settings
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*
                  const Text(
                    'Paramètres d\'invite d\'application',
                    style: TextStyle(color: Colors.white),
                  ),*/
                  const Text(
                      'Paramètres d\'invité d\'application: c\'est l\'heure de l\'eau',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  InkWell(
                    onTap: () {
                      _showNotificationTextDialog();
                    },
                    child: Row(
                      children: [
                        const Text(
                          'C\'est l\'heure de l\'e...',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Water goal section
              const Text(
                'objectif de boire de l\'eau',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              // Set water goal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Fixer un objectif de\nconsommation d\'eau',
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () => _showWaterGoalDialog(),
                    child: Row(
                      children: [
                        Text(
                          '${waterGoal}ml',
                          style: const TextStyle(color: Colors.blue),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Auto calculate goal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Objectif de calcul automatique',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Définissez automatiquement votre consommation\nd\'eau en fonction de votre poids, de votre âge, de\nvotre sexe et de votre niveau d\'activité quotidien.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  Switch(
                    value: autoCalculate,
                    onChanged: (value) {
                      setState(() {
                        autoCalculate = value;
                        if (value) {
                          // Simulate automatic calculation
                          waterGoal = 2500; // Example value
                        }
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Save button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Paramètres enregistrés'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.blue,
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeBox(int value) {
    return Container(
      width: 48,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Center(
        child: Text(
          value.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCountBox(int value) {
    return Container(
      width: 48,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  void _showTimePickerDialog(bool isHour) {
    showDialog(
      context: context,
      builder: (context) {
        int selectedValue = isHour ? startHour : startMinute;
        final maxValue = isHour ? 23 : 59;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                isHour ? 'Sélectionner l\'heure' : 'Sélectionner les minutes',
              ),
              content: SizedBox(
                height: 200,
                width: 100,
                child: ListView.builder(
                  itemCount: maxValue + 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        index.toString().padLeft(2, '0'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedValue == index ? Colors.blue : null,
                          fontWeight:
                              selectedValue == index ? FontWeight.bold : null,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedValue = index;
                        });
                      },
                      selected: selectedValue == index,
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isHour) {
                      this.setState(() {
                        startHour = selectedValue;
                      });
                    } else {
                      this.setState(() {
                        startMinute = selectedValue;
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showNumberPickerDialog(
    String title,
    int minValue,
    int maxValue,
    int currentValue,
    Function(int) onValueChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        int selectedValue = currentValue;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                height: 200,
                width: 100,
                child: ListView.builder(
                  itemCount: maxValue - minValue + 1,
                  itemBuilder: (context, index) {
                    final value = minValue + index;
                    return ListTile(
                      title: Text(
                        value.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedValue == value ? Colors.blue : null,
                          fontWeight:
                              selectedValue == value ? FontWeight.bold : null,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      selected: selectedValue == value,
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    onValueChanged(selectedValue);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showNotificationTextDialog() {
    String notificationText = 'C\'est l\'heure de l\'eau';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Message de rappel'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Écrivez le message de rappel:'),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Message de rappel',
                  ),
                  controller: TextEditingController(text: notificationText),
                  onChanged: (value) {
                    notificationText = value;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save notification text
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Message de rappel enregistré'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
    );
  }

  void _showWaterGoalDialog() {
    int tempGoal = waterGoal;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Objectif de consommation d\'eau'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Entrez votre objectif quotidien en ml:'),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'ml',
                  ),
                  controller: TextEditingController(text: waterGoal.toString()),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      tempGoal = int.tryParse(value) ?? waterGoal;
                    }
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPresetButton(1500, tempGoal, (val) {
                      tempGoal = val;
                      (context as Element).markNeedsBuild();
                    }),
                    _buildPresetButton(2000, tempGoal, (val) {
                      tempGoal = val;
                      (context as Element).markNeedsBuild();
                    }),
                    _buildPresetButton(2500, tempGoal, (val) {
                      tempGoal = val;
                      (context as Element).markNeedsBuild();
                    }),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    waterGoal = tempGoal;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
    );
  }

  Widget _buildPresetButton(
    int value,
    int selectedValue,
    Function(int) onSelected,
  ) {
    final isSelected = value == selectedValue;

    return GestureDetector(
      onTap: () => onSelected(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${value}ml',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
