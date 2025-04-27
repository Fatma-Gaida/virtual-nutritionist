import 'package:flutter/material.dart';

class AddPlatScreen extends StatefulWidget {
  const AddPlatScreen({super.key});

  @override
  State<AddPlatScreen> createState() => _AddPlatScreenState();
}

class _AddPlatScreenState extends State<AddPlatScreen> {
  final TextEditingController _platNameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  String? _selectedMealType;
  bool _isLoading = false;
  double _buttonScale = 1.0;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Trigger animation on screen load
    Future.delayed(Duration.zero, () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  void dispose() {
    _platNameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _handleAddPlat() async {
    final platName = _platNameController.text.trim();
    final calories = _caloriesController.text.trim();

    if (platName.isEmpty || calories.isEmpty || _selectedMealType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Plat added successfully'),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 4),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString().contains('Exception:')
            ? e.toString().split('Exception:')[1].trim()
            : e.toString();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Add New Consumed Recipe',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[700]!, Colors.green[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  transform: Matrix4.translationValues(
                      0, _isVisible ? 0 : 20, 0),
                  child: Text(
                    'Track Your Meals',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  transform: Matrix4.translationValues(
                      0, _isVisible ? 0 : 20, 0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedMealType,
                      hint: const Text('Select Meal Type'),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.restaurant_menu,
                          color: Colors.green[700],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      items: ['Breakfast', 'Lunch', 'Dinner']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMealType = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  transform: Matrix4.translationValues(
                      0, _isVisible ? 0 : 20, 0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _platNameController,
                      decoration: InputDecoration(
                        hintText: 'Plat Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.fastfood,
                          color: Colors.green[700],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  transform: Matrix4.translationValues(
                      0, _isVisible ? 0 : 20, 0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _caloriesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Calories',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.local_fire_department,
                          color: Colors.green[700],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  transform: Matrix4.translationValues(
                      0, _isVisible ? 0 : 20, 0),
                  child: GestureDetector(
                    onTapDown: (_) {
                      if (!_isLoading) {
                        setState(() {
                          _buttonScale = 0.95;
                        });
                      }
                    },
                    onTapUp: (_) {
                      if (!_isLoading) {
                        setState(() {
                          _buttonScale = 1.0;
                        });
                      }
                    },
                    onTapCancel: () {
                      setState(() {
                        _buttonScale = 1.0;
                      });
                    },
                    child: AnimatedScale(
                      scale: _buttonScale,
                      duration: const Duration(milliseconds: 100),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleAddPlat,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0), // Remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.green[700]!.withOpacity(0.4),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green[700]!, Colors.green[400]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12), // Match form field padding
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Add Plat',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedOpacity(
                opacity: _isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  transform: Matrix4.translationValues(
                      0, _isVisible ? 0 : 20, 0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back to Calorie Tracker',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}