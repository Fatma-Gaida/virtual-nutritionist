import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'water_settings_screen.dart';
import 'water_history_screen.dart'; // New import for the history screen


class WaterTrackerScreen extends StatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen>
    with SingleTickerProviderStateMixin {
  int currentIntake = 0; // Starting with 0ml
  int target = 2000;
  List<WaterIntake> intakeHistory = [];
  late AnimationController _animationController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _waveAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void addWaterIntake(int amount) {
    setState(() {
      // Don't add if amount is 0 or negative
      if (amount <= 0) return;

      // Don't add more than what's needed to reach target
      final remaining = target - currentIntake;
      final finalAmount = amount > remaining ? remaining : amount;

      if (finalAmount > 0) {
        intakeHistory.insert(
          0,
          WaterIntake(amount: finalAmount, time: DateTime.now()),
        );
        currentIntake += finalAmount;
      }
    });
  }

  void removeWaterIntake(int index) {
    setState(() {
      if (index >= 0 && index < intakeHistory.length) {
        currentIntake -= intakeHistory[index].amount;
        if (currentIntake < 0) currentIntake = 0;
        intakeHistory.removeAt(index);
      }
    });
  }

  bool isButtonDisabled(int amount) {
    return amount > (target - currentIntake);
  }

  @override
  Widget build(BuildContext context) {
    double percentage = currentIntake / target;
    int remaining = target - currentIntake;

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'rappel de boire de l\'eau',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // History button - navigates to the dedicated history screen
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'Historique',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => WaterHistoryScreen(
                        intakeHistory: intakeHistory,
                        onRemoveIntake: removeWaterIntake,
                      ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WaterSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$currentIntake',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'ml',
                      style: TextStyle(color: Colors.white70, fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'objectif de boisson d\'eau: ${target}ml',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    // Improved glass with water level and enhanced wave effect
                    AnimatedBuilder(
                      animation: _waveAnimation,
                      builder: (context, child) {
                        return SizedBox(
                          height: 200,
                          width: 120,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Empty glass
                              Container(
                                width: 100,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white30,
                                    width: 2,
                                  ),
                                ),
                              ),
                              // Water level with enhanced wave effect
                              ClipPath(
                                clipper: EnhancedWaveClipper(
                                  animation: _waveAnimation.value,
                                  fillPercentage: percentage,
                                ),
                                child: Container(
                                  width: 100,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              // Percentage text
                              Positioned(
                                bottom:
                                    percentage > 0.1
                                        ? 180 * percentage / 2 - 10
                                        : 5,
                                child: Text(
                                  '${(percentage * 100).toInt()}%',
                                  style: TextStyle(
                                    color:
                                        percentage > 0.2
                                            ? Colors.blue
                                            : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'boire de l\'eau : ${(percentage * 100).toInt()}% de la cible',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    // Improved water intake buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildWaterButton(100, isButtonDisabled(100)),
                        const SizedBox(width: 20),
                        _buildWaterButton(200, isButtonDisabled(200)),
                        const SizedBox(width: 20),
                        _buildWaterButton(400, isButtonDisabled(400)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Add custom water intake button
                    ElevatedButton(
                      onPressed:
                          remaining > 0
                              ? () => _showAddCustomIntakeDialog()
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade700,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Ajouter une prise d\'eau',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // View history button - directs to history screen
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => WaterHistoryScreen(
                                  intakeHistory: intakeHistory,
                                  onRemoveIntake: removeWaterIntake,
                                ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.history, color: Colors.white),
                      label: const Text(
                        'Voir l\'historique',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterButton(int amount, bool disabled) {
    return InkWell(
      onTap: disabled ? null : () => addWaterIntake(amount),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Glass container
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(disabled ? 0.3 : 1.0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white30, width: 1),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Water in glass
                    Container(
                      width: 60,
                      height: 60 * 0.7, // 70% full
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(7),
                          bottomRight: Radius.circular(7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Add icon
              Icon(
                Icons.add,
                color: disabled ? Colors.grey : Colors.blue,
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${amount}ml',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCustomIntakeDialog() {
    int customAmount = 100;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Ajouter la consommation d\'eau'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Entrez la quantité en ml:'),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'ml',
                  ),
                  controller: TextEditingController(text: '100'),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      customAmount = int.tryParse(value) ?? 100;
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickAmountButton(100, (val) {
                      customAmount = val;
                      (context as Element).markNeedsBuild();
                    }),
                    _buildQuickAmountButton(200, (val) {
                      customAmount = val;
                      (context as Element).markNeedsBuild();
                    }),
                    _buildQuickAmountButton(300, (val) {
                      customAmount = val;
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
                  addWaterIntake(customAmount);
                  Navigator.pop(context);
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
    );
  }

  Widget _buildQuickAmountButton(int value, Function(int) onSelected) {
    return ElevatedButton(
      onPressed: () => onSelected(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text('${value}ml'),
    );
  }
}

// Modified custom clipper for the wave effect - ensuring clipping is bounded
class EnhancedWaveClipper extends CustomClipper<Path> {
  final double animation;
  final double fillPercentage;

  EnhancedWaveClipper({required this.animation, required this.fillPercentage});

  @override
  Path getClip(Size size) {
    final path = Path();
    final height = size.height;
    final width = size.width;

    // Ensure valid fill percentage (0 to 1)
    final validFillPercentage = fillPercentage.clamp(0.0, 1.0);

    // Determine the water level height
    final waterHeight = height * (1 - validFillPercentage);

    // Start from bottom-left corner
    path.moveTo(0, height);

    // Right edge of rectangle
    path.lineTo(width, height);

    // Limit to very small wave if nearly empty
    if (validFillPercentage < 0.05) {
      path.lineTo(width, height - 5);
      path.lineTo(0, height - 5);
      path.close();
      return path;
    }

    // Create wave at the water surface
    final waveHeight = math.min(10.0, height * validFillPercentage * 0.2);
    final waveWidth = width / 1.5;

    // Top edge with wave
    path.lineTo(width, waterHeight);

    // For very low fill, make a simpler wave
    if (validFillPercentage < 0.1) {
      final midPoint = width / 2;
      path.lineTo(
        midPoint + waveWidth / 4 * math.sin(animation * math.pi),
        waterHeight - waveHeight / 2 * math.cos(animation * math.pi),
      );
      path.lineTo(0, waterHeight);
    } else {
      // Create multiple wave points for a more realistic effect - ensure clipping stays in bounds
      for (double i = width; i >= 0; i -= 10) {
        final dx = i;
        final dy =
            waterHeight +
            waveHeight * math.sin((animation * 360 - i) / 180 * math.pi);

        // Ensure dy is always within the container bounds
        final clampedDy = math.max(0, math.min(height, dy)) as double;
        path.lineTo(dx, clampedDy);
      }
    }

    // Close the path
    path.lineTo(0, height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
