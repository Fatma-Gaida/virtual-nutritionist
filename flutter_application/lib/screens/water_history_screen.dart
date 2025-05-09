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
    // Define color scheme to match nutrition app - same as in WaterTrackerScreen
    final primaryGreen = Color(0xFF4CAF50);
    final darkGreen = Color(0xFF388E3C);
    final lightBlue = Color(0xFF81D4FA); // Light blue for water

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Water History',
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
              ? _buildEmptyState(lightBlue)
              : _buildHistoryList(primaryGreen, darkGreen, lightBlue),
    );
  }

  Widget _buildEmptyState(Color waterColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: 80,
            color: waterColor.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'No water intake recorded',
            style: TextStyle(color: Colors.grey[800], fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Add water from the main screen',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(
    Color primaryGreen,
    Color darkGreen,
    Color waterColor,
  ) {
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
          color: waterColor.withOpacity(0.2),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: primaryGreen),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_formatDate(today)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '$todayIntake ml',
                style: TextStyle(
                  color: primaryGreen,
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
                    SnackBar(
                      content: const Text('Record deleted'),
                      backgroundColor: darkGreen,
                    ),
                  );
                },
                background: Container(
                  color: Colors.red[400],
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
                    leading: _buildGlassIcon(intake.amount, waterColor),
                    title: Text(
                      '${intake.amount} ml',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'On $date',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$hour:$minute',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red[400],
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

  Widget _buildGlassIcon(int amount, Color waterColor) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Glass container
        Container(
          width: 32,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.blue, width: 1),
          ),
        ),
        // Water in glass
        Container(
          width: 32,
          height: 40 * 0.75, // Assuming each glass shows 75% full
          decoration: BoxDecoration(
            color: waterColor.withOpacity(0.7),
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
    final primaryGreen = Color(0xFF4CAF50);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Clear History', style: TextStyle(color: primaryGreen)),
            content: const Text(
              'Are you sure you want to clear all history records? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  // Clear all history
                  for (int i = widget.intakeHistory.length - 1; i >= 0; i--) {
                    widget.onRemoveIntake(i);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
