import 'dart:typed_data';

import 'package:e_commerce_admin/core/service/cloudinary_service.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/data/models/category_model.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/presentation/cubit/category_cubit.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/presentation/cubit/category_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddEditCategoryScreen extends StatefulWidget {
  final AdminCategoryModel? category;

  const AddEditCategoryScreen({
    super.key,
    this.category,
  });

  bool get isEditing => category != null;

  @override
  State<AddEditCategoryScreen> createState() =>
      _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState
    extends State<AddEditCategoryScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  late final TextEditingController _nameController;

  final CloudinaryService _cloudinaryService =
      CloudinaryService();

  Uint8List? _imageBytes;

  String _imageUrl = '';

  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.category?.name ?? '',
    );

    _imageUrl = widget.category?.image ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

Future<void> _pickImage() async {
  if (_isUploadingImage) {
    return;
  }

  try {
    final file = await FilePicker.pickFile(
      type: FileType.image,
    );

    if (file == null) {
      return;
    }

    final bytes = await file.readAsBytes();

    if (bytes.isEmpty) {
      _showError(
        'Could not read the selected image.',
      );
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _imageBytes = bytes;
    });
  } catch (e) {
    if (!mounted) {
      return;
    }

    _showError(
      'Failed to select image: $e',
    );
  }
}


  Future<bool> _uploadImageIfNeeded() async {
    if (_imageBytes == null) {
      return true;
    }

    if (!mounted) {
      return false;
    }

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final url =
          await _cloudinaryService.uploadImage(
        _imageBytes!,
      );

      if (!mounted) {
        return false;
      }

      setState(() {
        _imageUrl = url;
        _isUploadingImage = false;
      });

      return true;
    } catch (e) {
      if (!mounted) {
        return false;
      }

      setState(() {
        _isUploadingImage = false;
      });

      _showError(
        e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
      );

      return false;
    }
  }

  Future<void> _saveCategory() async {
    if (_isUploadingImage) {
      return;
    }

    final isValid =
        _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    final uploaded =
        await _uploadImageIfNeeded();

    if (!uploaded || !mounted) {
      return;
    }

    if (_imageUrl.isEmpty) {
      _showError(
        'Please select a category image.',
      );
      return;
    }

    final category = AdminCategoryModel(
      id: widget.category?.id ?? '',
      name: _nameController.text.trim(),
      image: _imageUrl,
    );

    final cubit =
        context.read<CategoryCubit>();

    if (widget.isEditing) {
      await cubit.updateCategory(category);
    } else {
      await cubit.createCategory(category);
    }
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEditing
        ? 'Edit Category'
        : 'Add Category';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategorySuccess) {
            if (!mounted) {
              return;
            }

            context.pop();
            return;
          }

          if (state is CategoryError) {
            _showError(state.message);
          }
        },
        builder: (context, state) {
          final bool isSaving =
              state is CategoryLoading;

          final bool isBusy =
              isSaving || _isUploadingImage;

          return AbsorbPointer(
            absorbing: isBusy,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Category Information',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 24),

                        TextFormField(
                          controller:
                              _nameController,
                          textInputAction:
                              TextInputAction.next,
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Category Name',
                            hintText:
                                'Enter category name',
                            prefixIcon: Icon(
                              Icons.category,
                            ),
                            border:
                                OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final text =
                                value?.trim() ?? '';

                            if (text.isEmpty) {
                              return
                                  'Please enter category name';
                            }

                            if (text.length < 2) {
                              return
                                  'Category name is too short';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Category Image',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        InkWell(
                          onTap: isBusy
                              ? null
                              : _pickImage,
                          borderRadius:
                              BorderRadius.circular(16),
                          child: Container(
                            height: 280,
                            width: double.infinity,
                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                              border: Border.all(
                                color:
                                    Theme.of(context)
                                        .dividerColor,
                              ),
                            ),
                            clipBehavior:
                                Clip.antiAlias,
                            child:
                                _buildImagePreview(),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Click the image area to select a category image.',
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color,
                          ),
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          height: 52,
                          child:
                              FilledButton(
                            onPressed: isBusy
                                ? null
                                : _saveCategory,
                            child: isBusy
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    widget.isEditing
                                        ? 'Update Category'
                                        : 'Create Category',
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
        },
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imageBytes != null) {
      return Image.memory(
        _imageBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder:
            (context, error, stackTrace) {
          return _imagePlaceholder();
        },
      );
    }

    if (_imageUrl.isNotEmpty) {
      return Image.network(
        _imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder:
            (context, error, stackTrace) {
          return _imagePlaceholder();
        },
        loadingBuilder:
            (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }

    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return const Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          size: 64,
        ),
        SizedBox(height: 12),
        Text(
          'Select Category Image',
        ),
      ],
    );
  }
}
