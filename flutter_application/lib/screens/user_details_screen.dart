import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  //const UserDetailsScreen({Key? key}) : super(key: key);
  const UserDetailsScreen({super.key});
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // State variables initialized as null/empty
  DateTime? _birthday;
  double? _height;
  int? _weight;
  String? _weightUnit;
  String? _gender;
  String? _activityLevel;
  String? _mainGoal;
  List<String> _maladies = [];
  List<String> _allergies = [];

  

  final List<String> _activityLevels = [
    'Sedentary (little or no exercise)',
    'Lightly active (light exercise 1-3 days/week)',
    'Moderately active (moderate exercise 3-5 days/week)',
    'Very active (hard exercise 6-7 days/week)',
  
  ];

  final List<String> _availableMaladies = [
    'Diabetes',
    'Hypertension',
    'Asthma',
    'Heart Disease',
    'None'
  ];

  final List<String> _availableAllergies = [
    'Peanuts',
    'Dairy',
    'Gluten',
    'Shellfish',
    'None'
  ];

  final List<Map<String, dynamic>> _mainGoals = [
    {'title': 'Lose weight', 'emoji': '📉'},
    {'title': 'Keep fit', 'emoji': '🍀'},
    {'title': 'Get stronger', 'emoji': '💪'},
    {'title': 'Gain muscle mass', 'emoji': '🏋️'},
  ];

  // Method to handle weight unit conversion
  void _convertWeight(String? newUnit) {
    if (_weightUnit == newUnit || _weight == null || newUnit == null) return;
    setState(() {
      if (newUnit == 'pound') {
        _weight = (_weight! * 2.20462).round();
      } else {
        _weight = (_weight! / 2.20462).round();
      }
      _weightUnit = newUnit;
    });
  }

  // Method to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthday = picked;
      });
    }
  }

  // Validation methods
  bool _validatePhase1() {
    return _gender != null &&
        _birthday != null &&
        _height != null &&
        _weight != null &&
        _weightUnit != null;
  }

  bool _validatePhase2() {
    return _activityLevel != null;
  }

  bool _validatePhase3() {
    return _maladies.isNotEmpty && _allergies.isNotEmpty;
  }

  bool _validatePhase4() {
    return _mainGoal != null;
  }

  void _nextPage() {
    bool isValid = false;
    switch (_currentPage) {
      case 0:
        isValid = _validatePhase1();
        break;
      case 1:
        isValid = _validatePhase2();
        break;
      case 2:
        isValid = _validatePhase3();
        break;
      case 3:
        isValid = _validatePhase4();
        break;
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      print('Form completed: $_gender, $_birthday, $_height, '
          '$_weight, $_activityLevel, $_maladies, $_allergies, $_mainGoal');
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text(
          'Create account',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _Phase1(
            gender: _gender,
            ongenderChanged: (value) => setState(() => _gender = value),
            birthday: _birthday,
            onBirthdayChanged: _selectDate,
            height: _height,
            onHeightChanged: (value) => setState(() => _height = value),
            weight: _weight,
            onWeightChanged: (value) => setState(() => _weight = value),
            weightUnit: _weightUnit,
            onWeightUnitChanged: _convertWeight,
            onNext: _nextPage,
          ),
          _Phase2(
            activityLevel: _activityLevel,
            onActivityLevelChanged: (value) => setState(() => _activityLevel = value),
            activityLevels: _activityLevels,
            onNext: _nextPage,
          ),
          _Phase3(
            maladies: _maladies,
            allergies: _allergies,
            availableMaladies: _availableMaladies,
            availableAllergies: _availableAllergies,
            onMaladiesChanged: (value) => setState(() => _maladies = value),
            onAllergiesChanged: (value) => setState(() => _allergies = value),
            onNext: _nextPage,
          ),
          _Phase4(
            mainGoal: _mainGoal,
            onMainGoalChanged: (value) => setState(() => _mainGoal = value),
            mainGoals: _mainGoals,
            onNext: _nextPage,
          ),
        ],
      ),
    );
  }
}

class _Phase1 extends StatelessWidget {
  final String? gender;
  final ValueChanged<String> ongenderChanged;
  final DateTime? birthday;
  final Function(BuildContext) onBirthdayChanged;
  final double? height;
  final ValueChanged<double> onHeightChanged;
  final int? weight;
  final ValueChanged<int> onWeightChanged;
  final String? weightUnit;
  final ValueChanged<String?> onWeightUnitChanged;
  final VoidCallback onNext;

  const _Phase1({
    required this.gender,
    required this.ongenderChanged,
    required this.birthday,
    required this.onBirthdayChanged,
    required this.height,
    required this.onHeightChanged,
    required this.weight,
    required this.onWeightChanged,
    required this.weightUnit,
    required this.onWeightUnitChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => ongenderChanged('Men'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: gender == 'Men' ? Colors.green[700] : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          'Men',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: gender == 'Men' ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: gender == 'Men' ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => ongenderChanged('Women'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: gender == 'Women' ? Colors.green[700] : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          'Women',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: gender == 'Women' ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: gender == 'Women' ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Birthday', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => onBirthdayChanged(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        birthday != null 
                          ? '${birthday!.day}/${birthday!.month}/${birthday!.year}' 
                          : 'Select date',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.green),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              const Text('Height', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('100 cm', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  Text('220 cm', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
              Slider(
                value: height ?? 100,
                min: 100,
                max: 220,
                divisions: 120,
                activeColor: Colors.green[700],
                inactiveColor: Colors.grey[300],
                label: height != null ? '${height!.round()} cm' : 'Select height',
                onChanged: onHeightChanged,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    height != null ? '${height!.round()} cm' : 'Not set',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Weight', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _NumberInputField(
                      value: weight ?? 20,
                      onChanged: onWeightChanged,
                      minValue: 20,
                      maxValue: 200,
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: weightUnit,
                    hint: const Text('Unit'),
                    items: <String>['kg', 'pound'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      );
                    }).toList(),
                    onChanged: onWeightUnitChanged,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.findAncestorStateOfType<_UserDetailsScreenState>()?._previousPage(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Previous', style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Phase2 extends StatelessWidget {
  final String? activityLevel;
  final ValueChanged<String> onActivityLevelChanged;
  final List<String> activityLevels;
  final VoidCallback onNext;

  const _Phase2({
    required this.activityLevel,
    required this.onActivityLevelChanged,
    required this.activityLevels,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose your activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 12,
                  childAspectRatio: 4,
                ),
                itemCount: activityLevels.length,
                itemBuilder: (context, index) {
                  final activity = activityLevels[index];
                  final isSelected = activityLevel == activity;
                  return GestureDetector(
                    onTap: () => onActivityLevelChanged(activity),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green[700] : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? Colors.green[700]! : Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Text(
                        activity,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.findAncestorStateOfType<_UserDetailsScreenState>()?._previousPage(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Previous', style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Phase3 extends StatelessWidget {
  final List<String> maladies;
  final List<String> allergies;
  final List<String> availableMaladies;
  final List<String> availableAllergies;
  final ValueChanged<List<String>> onMaladiesChanged;
  final ValueChanged<List<String>> onAllergiesChanged;
  final VoidCallback onNext;

  const _Phase3({
    required this.maladies,
    required this.allergies,
    required this.availableMaladies,
    required this.availableAllergies,
    required this.onMaladiesChanged,
    required this.onAllergiesChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Do you have any medical conditions?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: availableMaladies.map((condition) {
                  final isSelected = maladies.contains(condition);
                  return ChoiceChip(
                    label: Text(condition),
                    selected: isSelected,
                    onSelected: (selected) {
                      List<String> updatedMaladies = List.from(maladies);
                      if (condition == 'None') {
                        updatedMaladies.clear();
                        if (selected) updatedMaladies.add('None');
                      } else {
                        updatedMaladies.remove('None');
                        if (selected) {
                          updatedMaladies.add(condition);
                        } else {
                          updatedMaladies.remove(condition);
                        }
                      }
                      onMaladiesChanged(updatedMaladies);
                    },
                    selectedColor: Colors.green[700],
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text('Do you have any allergies?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: availableAllergies.map((allergy) {
                  final isSelected = allergies.contains(allergy);
                  return ChoiceChip(
                    label: Text(allergy),
                    selected: isSelected,
                    onSelected: (selected) {
                      List<String> updatedAllergies = List.from(allergies);
                      if (allergy == 'None') {
                        updatedAllergies.clear();
                        if (selected) updatedAllergies.add('None');
                      } else {
                        updatedAllergies.remove('None');
                        if (selected) {
                          updatedAllergies.add(allergy);
                        } else {
                          updatedAllergies.remove(allergy);
                        }
                      }
                      onAllergiesChanged(updatedAllergies);
                    },
                    selectedColor: Colors.green[700],
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.findAncestorStateOfType<_UserDetailsScreenState>()?._previousPage(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Previous', style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Phase4 extends StatelessWidget {
  final String? mainGoal;
  final ValueChanged<String> onMainGoalChanged;
  final List<Map<String, dynamic>> mainGoals;
  final VoidCallback onNext;

  const _Phase4({
    required this.mainGoal,
    required this.onMainGoalChanged,
    required this.mainGoals,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Choose main goal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 12,
                  childAspectRatio: 4,
                ),
                itemCount: mainGoals.length,
                itemBuilder: (context, index) {
                  final goal = mainGoals[index];
                  final isSelected = mainGoal == goal['title'];
                  return GestureDetector(
                    onTap: () => onMainGoalChanged(goal['title']),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green[700] : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? Colors.green[700]! : Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(goal['emoji'], style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              goal['title'],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Finish', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.findAncestorStateOfType<_UserDetailsScreenState>()?._previousPage(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Previous', style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NumberInputField extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int minValue;
  final int maxValue;

  const _NumberInputField({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.minValue,
    required this.maxValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.green),
            onPressed: value > minValue ? () => onChanged(value - 1) : null,
          ),
          Expanded(
            child: Text('$value', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.green),
            onPressed: value < maxValue ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}