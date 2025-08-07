import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/widgets.dart';

class UserProfileDetailScreen extends ConsumerStatefulWidget {
  const UserProfileDetailScreen({super.key});

  @override
  ConsumerState<UserProfileDetailScreen> createState() => _UserProfileDetailViewState();
}

class _UserProfileDetailViewState extends ConsumerState<UserProfileDetailScreen> {
  bool _hasFetchedProfile = false;
  bool _isEditing = false;
  bool _isLoading = false;
  
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  
  // Image picker
  File? _selectedImage;
  String? _currentProfileImage;

  @override
  void initState() {
    super.initState();
    print('👤 UserProfileDetailView initState called');
    
    // Fetch profile data only once when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasFetchedProfile) {
        print('🔄 Fetching latest profile data...');
        _hasFetchedProfile = true;
        ref.read(authViewModelProvider.notifier).fetchUserProfile();
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _startEditing(User user) {
    setState(() {
      _isEditing = true;
      _firstNameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _mobileController.text = user.mobile ?? '';
      _currentProfileImage = user.profileImage;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _selectedImage = null;
      _firstNameController.clear();
      _lastNameController.clear();
      _mobileController.clear();
    });
  }

  Future<void> _pickImage() async {
    // TODO: Implement image picker
    // For now, we'll just show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image picker will be implemented'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('No authentication token available');
      }

      final url = Uri.parse('https://backend.citydoctor.ae/v1/profile/update/');
      
      // Prepare request body
      final Map<String, dynamic> requestBody = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
      };

      // Add mobile if provided
      if (_mobileController.text.trim().isNotEmpty) {
        requestBody['mobile'] = _mobileController.text.trim();
      }

      // Add profile image if selected
      if (_selectedImage != null) {
        // TODO: Convert image to Base64
        // requestBody['profile_image'] = base64Image;
      } else if (_currentProfileImage != null) {
        // Keep existing image
        requestBody['profile_image'] = _currentProfileImage;
      }

      print('🌐 Updating profile at: $url');
      print('📦 Request body: $requestBody');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      print('📡 Profile update response status: ${response.statusCode}');
      print('📡 Profile update response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Profile updated successfully: $data');

        // Update local user data
        ref.read(authViewModelProvider.notifier).fetchUserProfile();

        setState(() {
          _isEditing = false;
          _selectedImage = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        print('❌ Validation errors: $errorData');
        
        String errorMessage = 'Validation failed:\n';
        errorData.forEach((field, errors) {
          errorMessage += '• ${errors.join(', ')}\n';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final authState = ref.watch(authViewModelProvider);
    
    // Debug prints
    print('👤 UserProfileDetailView - Current User: ${currentUser?.name}');
    print('📧 User Email: ${currentUser?.email}');
    print('🆔 User ID: ${currentUser?.id}');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isEditing && currentUser != null)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: () => _startEditing(currentUser),
            ),
        ],
      ),
      body: authState is AuthLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  _buildProfilePicture(currentUser),
                  
                  const SizedBox(height: 30),
                  
                  // Profile Information
                  _isEditing 
                      ? _buildEditForm(currentUser)
                      : _buildProfileInfo(currentUser),
                ],
              ),
            ),
    );
  }

  Widget _buildProfilePicture(User? user) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[400]!, width: 3),
            ),
            child: user?.profileImage != null
                ? ClipOval(
                    child: Image.network(
                      user!.profileImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey,
                  ),
          ),
          if (_isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  onPressed: _pickImage,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEditForm(User? user) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          
          _buildInfoCard([
            _buildEditField(
              'First Name',
              _firstNameController,
              'Enter first name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'First name is required';
                }
                if (value.trim().length < 3) {
                  return 'First name must be at least 3 characters';
                }
                return null;
              },
            ),
            _buildEditField(
              'Last Name',
              _lastNameController,
              'Enter last name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Last name is required';
                }
                if (value.trim().length < 3) {
                  return 'Last name must be at least 3 characters';
                }
                return null;
              },
            ),
            _buildEditField(
              'Mobile',
              _mobileController,
              'Enter mobile number',
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  if (value.trim().length < 10) {
                    return 'Mobile number must be at least 10 digits';
                  }
                }
                return null;
              },
            ),
          ]),
          
          const SizedBox(height: 20),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Cancel',
                  onPressed: _isLoading ? null : _cancelEditing,
                  backgroundColor: Colors.grey,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  text: _isLoading ? 'Updating...' : 'Save Changes',
                  onPressed: _isLoading ? null : _updateProfile,
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller,
    String hint, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.error),
              ),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        
        _buildInfoCard([
          _buildInfoRow('Full Name', user?.name ?? 'Not Available'),
          _buildInfoRow('Email', user?.email ?? 'Not Available'),
          _buildInfoRow('User ID', user?.id.toString() ?? 'Not Available'),
          _buildInfoRow('Mobile', user?.mobile ?? 'Not Available'),
          _buildInfoRow('Status', user?.status ?? 'Not Available'),
        ]),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 