import 'package:flutter/material.dart';

// Import the WaterIntake class from your main file
// For the purpose of this example, I'm redefining it here
class WaterIntake {
  final int amount;
  final DateTime time;

  WaterIntake({required this.amount, required this.time});
}

class WaterHistoryScreen extends StatefulWidget {
  final List<WaterIntake> intakeHistory;
  final Function(int) onRemoveIntake;

  const WaterHistoryScreen({
    Key? key,
    required this.intakeHistory,
    required this.onRemoveIntake,
  }) : super(key: key);

  @override
  State<WaterHistoryScreen> createState() => _WaterHistoryScreenState();
}

class _WaterHistoryScreenState extends State<WaterHistoryScreen> {
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
        title: const Text(
          'registres de boissons à l\'eau',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // Add clear all button if needed
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed:
                widget.intakeHistory.isEmpty
                    ? null
                    : () {
                      _showClearConfirmationDialog();
                    },
          ),
        ],
      ),
      body:
          widget.intakeHistory.isEmpty
              ? _buildEmptyState()
              : _buildHistoryList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: 80,
            color: Colors.blue.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aucune consommation d\'eau enregistrée',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ajoutez de l\'eau depuis l\'écran principal',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    // Calculate total water consumption for the day
    final today = DateTime.now();
    final todayIntake = widget.intakeHistory
        .where((intake) => _isSameDay(intake.time, today))
        .fold(0, (sum, intake) => sum + intake.amount);

    return Column(
      children: [
        // Today's summary
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.withOpacity(0.1),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.blue),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Aujourd\'hui',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_formatDate(today)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '$todayIntake ml',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.intakeHistory.length,
            itemBuilder: (context, index) {
              final intake = widget.intakeHistory[index];
              final hour = intake.time.hour.toString().padLeft(2, '0');
              final minute = intake.time.minute.toString().padLeft(2, '0');
              final date = _formatDate(intake.time);

              return Dismissible(
                key: Key('intake_${intake.time.millisecondsSinceEpoch}'),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  widget.onRemoveIntake(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enregistrement supprimé'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: _buildGlassIcon(intake.amount),
                    title: Text(
                      '${intake.amount} ml',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Le $date',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$hour:$minute',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () => widget.onRemoveIntake(index),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGlassIcon(int amount) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Glass container
        Container(
          width: 32,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white30, width: 1),
          ),
        ),
        // Water in glass
        Container(
          width: 32,
          height: 40 * 0.75, // Assuming each glass shows 75% full
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
        ),
      ],
    );
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Effacer tout l\'historique'),
            content: const Text(
              'Êtes-vous sûr de vouloir effacer tous les enregistrements? Cette action ne peut pas être annulée.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Clear all history
                  for (int i = widget.intakeHistory.length - 1; i >= 0; i--) {
                    widget.onRemoveIntake(i);
                  }
                  Navigator.pop(context);
                  Navigator.pop(context); // Return to the main screen
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Effacer'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'jan',
      'fév',
      'mar',
      'avr',
      'mai',
      'juin',
      'juil',
      'août',
      'sep',
      'oct',
      'nov',
      'déc',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
