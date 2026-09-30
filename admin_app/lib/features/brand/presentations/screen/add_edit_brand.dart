import 'dart:typed_data';
import 'package:e_commerce_admin/core/service/cloudinary_service.dart';
import 'package:e_commerce_admin/features/brand/data/models/brand_model.dart';
import 'package:e_commerce_admin/features/brand/presentations/cubit/brand_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddEditBrandScreen extends StatefulWidget {
  final AdminBrandModel? brand;

  const AddEditBrandScreen({
    super.key,
    this.brand,
  });

  @override
  State<AddEditBrandScreen> createState() =>
      _AddEditBrandScreenState();
}

class _AddEditBrandScreenState
    extends State<AddEditBrandScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;

  final ImagePicker _imagePicker = ImagePicker();
  final CloudinaryService _cloudinaryService =
      CloudinaryService();
  Uint8List? _selectedImage;

  String _imageUrl = '';

  bool _isUploading = false;

  bool get _isEdit => widget.brand != null;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.brand?.name ?? '',
    );

    _imageUrl = widget.brand?.image ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isUploading) return;

    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) {
        return;
      }

      final bytes = await image.readAsBytes();

      if (bytes.isEmpty) {
        return;
      }

      if (!mounted) return;

      setState(() {
        _selectedImage = bytes;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to select image: $e',
          ),
        ),
      );
    }
  }

  Future<void> _saveBrand() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImage == null && _imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a brand image',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      String imageUrl = _imageUrl;

      if (_selectedImage != null) {
        imageUrl = await _uploadImage(
          _selectedImage!,
        );
      }

      final brand = AdminBrandModel(
        id: widget.brand?.id ?? '',
        name: _nameController.text.trim(),
        image: imageUrl,
      );

      if (_isEdit) {
        await context
            .read<BrandCubit>()
            .updateBrand(brand);
      } else {
        await context
            .read<BrandCubit>()
            .createBrand(brand);
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to save brand: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<String> _uploadImage(
    Uint8List bytes,
  ) async {
    final imageUrl = await _cloudinaryService.uploadImage(
      bytes,
    );

    if (imageUrl == null || imageUrl.isEmpty) {
      throw Exception(
        'Failed to upload image to Cloudinary',
      );
    }

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEdit ? 'Edit Brand' : 'Add Brand',
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEdit
                        ? 'Edit Brand'
                        : 'Add New Brand',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: _nameController,
                    decoration:
                        const InputDecoration(
                      labelText: 'Brand Name',
                      hintText: 'Enter brand name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter brand name';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Brand Image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: _isUploading
                        ? null
                        : _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                              child: Image.memory(
                                _selectedImage!,
                                fit: BoxFit.contain,
                              ),
                            )
                          : _imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(
                                    12,
                                  ),
                                  child: Image.network(
                                    _imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return const Icon(
                                        Icons
                                            .image_not_supported_outlined,
                                        size: 70,
                                      );
                                    },
                                  ),
                                )
                              : const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  children: [
                                    Icon(
                                      Icons
                                          .cloud_upload_outlined,
                                      size: 60,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      'Click to select image',
                                    ),
                                  ],
                                ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isUploading
                          ? null
                          : _saveBrand,
                      child: _isUploading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _isEdit
                                  ? 'Update Brand'
                                  : 'Create Brand',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}