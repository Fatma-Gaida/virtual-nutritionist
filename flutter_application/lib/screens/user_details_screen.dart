import 'package:flutter/material.dart';
import 'package:flutter_application/screens/profil_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
//import '../models/user.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  String? _selectedGender;
  String? _selectedActivity;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.nom ?? '');
    _heightController = TextEditingController(
      text: user?.taille != null ? user!.taille.toString() : '',
    );
    _weightController = TextEditingController(
      text: user?.poids != null ? user!.poids.toString() : '',
    );
    _selectedGender = user?.sexe;
    _selectedActivity = user?.etatActivite;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isSaving = true;
    });

    // In a real app, you would update the user data on the server here
    // For now, we'll just show a success message
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isSaving = false;
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.green),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          if (_isEditing)
            IconButton(
              icon: Icon(Icons.close, color: Colors.red[400]),
              onPressed: () {
                setState(() {
                  _isEditing = false;

                  // Reset controllers
                  final user =
                      Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).currentUser;
                  _nameController.text = user?.nom ?? '';
                  _heightController.text =
                      user?.taille != null ? user!.taille.toString() : '';
                  _weightController.text =
                      user?.poids != null ? user!.poids.toString() : '';
                  _selectedGender = user?.sexe;
                  _selectedActivity = user?.etatActivite;
                });
              },
            ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.currentUser;

          if (userProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green[700]),
            );
          }

          if (user == null) {
            return const Center(child: Text('User data not available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfilePic(),
                const SizedBox(height: 24),

                // Basic Information Section
                _buildSectionTitle('Basic Information'),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Full Name',
                  controller: _nameController,
                  enabled: _isEditing,
                  prefixIcon: Icons.person,
                ),

                const SizedBox(height: 16),
                _buildInfoRow(
                  label: 'Email',
                  value: user.email,
                  icon: Icons.email,
                ),

                const SizedBox(height: 16),
                _buildInfoRow(
                  label: 'Birth Date',
                  value:
                      user.dob != null
                          ? '${user.dob!.day}/${user.dob!.month}/${user.dob!.year}'
                          : 'Not provided',
                  icon: Icons.calendar_today,
                ),

                const SizedBox(height: 16),
                if (_isEditing)
                  _buildDropdown(
                    label: 'Gender',
                    value: _selectedGender,
                    items: const [
                      'Male',
                      'Female',
                      'Other',
                      'Prefer not to say',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    icon: Icons.person_outline,
                  )
                else
                  _buildInfoRow(
                    label: 'Gender',
                    value: user.sexe ?? 'Not provided',
                    icon: Icons.person_outline,
                  ),

                const SizedBox(height: 24),

                // Health Information Section
                _buildSectionTitle('Health Information'),
                const SizedBox(height: 16),

                _buildTextField(
                  label: 'Height (cm)',
                  controller: _heightController,
                  enabled: _isEditing,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.height,
                ),

                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Weight (kg)',
                  controller: _weightController,
                  enabled: _isEditing,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.fitness_center,
                ),

                const SizedBox(height: 16),
                if (_isEditing)
                  _buildDropdown(
                    label: 'Activity Level',
                    value: _selectedActivity,
                    items: const [
                      'Sedentary',
                      'Light',
                      'Moderate',
                      'Active',
                      'Very Active',
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedActivity = value;
                      });
                    },
                    icon: Icons.directions_run,
                  )
                else
                  _buildInfoRow(
                    label: 'Activity Level',
                    value: user.etatActivite ?? 'Not provided',
                    icon: Icons.directions_run,
                  ),

                const SizedBox(height: 24),

                // Medical Information Section
                _buildSectionTitle('Medical Information'),
                const SizedBox(height: 16),

                _buildInfoRow(
                  label: 'Allergies',
                  value:
                      user.allergies.isEmpty
                          ? 'None'
                          : user.allergies.join(', '),
                  icon: Icons.warning_amber,
                ),

                const SizedBox(height: 16),
                _buildInfoRow(
                  label: 'Medical Conditions',
                  value:
                      user.maladies.isEmpty ? 'None' : user.maladies.join(', '),
                  icon: Icons.medical_services,
                ),

                // Save button when editing
                if (_isEditing) ...[
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          _isSaving
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.green[800],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[700]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    required IconData prefixIcon,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: Colors.green[700]),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green[700]!, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[700]),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(label),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                items:
                    items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
