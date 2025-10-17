import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/petugas_controller.dart';
import '../../../../../../data/models/user.dart';

class EditPetugasDialog extends StatefulWidget {
  final User user;

  const EditPetugasDialog({super.key, required this.user});

  @override
  State<EditPetugasDialog> createState() => _EditPetugasDialogState();
}

class _EditPetugasDialogState extends State<EditPetugasDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _usernameController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late String _selectedRole;
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  bool _changePassword = false;

  final PetugasController _controller = Get.find<PetugasController>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _usernameController = TextEditingController(text: widget.user.username);
    _selectedRole = widget.user.role;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withValues(alpha: 0.7), // Dark overlay
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white, // Warna background dialog
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 5)),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.edit, color: Colors.orange),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('Edit Petugas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(32, 32)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Name Field
                _buildTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    if (value.trim().length < 3) {
                      return 'Nama minimal 3 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Field
                _buildTextField(
                  controller: _phoneController,
                  label: 'No. Telepon',
                  hint: 'Masukkan nomor telepon',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nomor telepon tidak boleh kosong';
                    }
                    if (value.trim().length < 10) {
                      return 'Nomor telepon minimal 10 digit';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Username Field
                _buildTextField(
                  controller: _usernameController,
                  label: 'Username',
                  hint: 'Masukkan username',
                  icon: Icons.alternate_email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    if (value.trim().length < 3) {
                      return 'Username minimal 3 karakter';
                    }
                    if (value.contains(' ')) {
                      return 'Username tidak boleh mengandung spasi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Role Dropdown
                const Text('Role', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: InputBorder.none,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'user',
                        child: Row(
                          children: [
                            Icon(Icons.cleaning_services, size: 16, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Petugas Cleaning'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'admin',
                        child: Row(
                          children: [
                            Icon(Icons.admin_panel_settings, size: 16, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Admin'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Change Password Checkbox
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: CheckboxListTile(
                    title: const Text('Ubah Password', style: TextStyle(fontSize: 14)),
                    value: _changePassword,
                    onChanged: (value) {
                      setState(() {
                        _changePassword = value!;
                        if (!_changePassword) {
                          _passwordController.clear();
                          _confirmPasswordController.clear();
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),

                // Password Fields (conditional)
                if (_changePassword) ...[
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password Baru',
                    hint: 'Masukkan password baru',
                    icon: Icons.lock,
                    isObscured: _isObscuredPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _isObscuredPassword = !_isObscuredPassword;
                      });
                    },
                    validator: (value) {
                      if (_changePassword) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    label: 'Konfirmasi Password Baru',
                    hint: 'Ulangi password baru',
                    icon: Icons.lock_outline,
                    isObscured: _isObscuredConfirmPassword,
                    onToggleVisibility: () {
                      setState(() {
                        _isObscuredConfirmPassword = !_isObscuredConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (_changePassword) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password tidak boleh kosong';
                        }
                        if (value != _passwordController.text) {
                          return 'Password tidak cocok';
                        }
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: _controller.isLoading.value ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _controller.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Update', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool isObscured = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isObscured,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            suffixIcon: onToggleVisibility != null
                ? IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off, size: 20),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.orange),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final success = await _controller.updateUser(
        id: widget.user.id,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        username: _usernameController.text.trim(),
        role: _selectedRole,
        password: _changePassword ? _passwordController.text : null,
      );

      if (success) {
        Navigator.of(context).pop();
        // Snackbar sudah ditampilkan oleh controller
      }
      // Error snackbar sudah ditampilkan oleh controller
    }
  }
}
