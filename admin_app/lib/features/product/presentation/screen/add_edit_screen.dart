import 'dart:typed_data';
import 'package:e_commerce_admin/core/di/injection_container.dart';
import 'package:e_commerce_admin/core/widgets/couustom_text_field_widget.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/data/models/category_model.dart';
import 'package:e_commerce_admin/features/brand/data/models/brand_model.dart';
import 'package:e_commerce_admin/features/product/data/model/product_model.dart';
import 'package:e_commerce_admin/features/product/presentation/cubit/prod_cubit.dart';
import 'package:e_commerce_admin/features/product/presentation/cubit/prod_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProductFormScreen extends StatefulWidget {
  final AdminProductModel? product;

  const ProductFormScreen({
    super.key,
    this.product,
  });

  bool get isEditing => product != null;

  @override
  State<ProductFormScreen> createState() =>
      _ProductFormScreenState();
}

class _ProductFormScreenState
    extends State<ProductFormScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  final TextEditingController _currentPriceController =
      TextEditingController();

  final TextEditingController _oldPriceController =
      TextEditingController();

  final TextEditingController _ratingController =
      TextEditingController();

  final TextEditingController _reviewsController =
      TextEditingController();

  final TextEditingController _stockController =
      TextEditingController();

  final ImagePicker _imagePicker =
      ImagePicker();

  List<AdminBrandModel> _brands = [];
  List<AdminCategoryModel> _categories = [];

  String? _selectedBrandId;
  String? _selectedCategoryId;

  String _imageUrl = '';

  Uint8List? _newImageBytes;

  final List<AdminProductColor> _colors = [];

  final List<AdminProductSize> _sizes = [
    const AdminProductSize(
      label: 'S',
      isAvailable: false,
    ),
    const AdminProductSize(
      label: 'M',
      isAvailable: false,
    ),
    const AdminProductSize(
      label: 'L',
      isAvailable: false,
    ),
    const AdminProductSize(
      label: 'XL',
      isAvailable: false,
    ),
    const AdminProductSize(
      label: '2XL',
      isAvailable: false,
    ),
  ];

  bool _loadingData = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    _fillProductData();
    _loadBrandsAndCategories();
  }

  void _fillProductData() {
    final product = widget.product;

    if (product == null) {
      return;
    }

    _nameController.text = product.name;

    _descriptionController.text =
        product.description;

    _currentPriceController.text =
        product.currentPrice.toString();

    _oldPriceController.text =
        product.oldPrice.toString();

    _ratingController.text =
        product.rating.toString();

    _reviewsController.text =
        product.reviewsCount.toString();

    _stockController.text =
        product.stockQuantity.toString();

    _selectedBrandId =
        product.brandId;

    _selectedCategoryId =
        product.categoryId;

    _imageUrl = product.image;

    _colors.addAll(product.colors);

    for (int i = 0;
        i < _sizes.length;
        i++) {
      final existing =
          product.sizes.where(
        (size) =>
            size.label ==
            _sizes[i].label,
      );

      if (existing.isNotEmpty) {
        _sizes[i] =
            existing.first;
      }
    }
  }

  Future<void>
      _loadBrandsAndCategories() async {
    try {
      final results =
          await Future.wait([
        brandRepository
            .getAllBrands(),
        categoryRepository
            .getAllCategories(),
      ]);

      if (!mounted) {
        return;
      }

      final brands =
          results[0]
              as List<AdminBrandModel>;

      final categories =
          results[1]
              as List<AdminCategoryModel>;

      setState(() {
        _brands = brands;
        _categories = categories;

        if (_selectedBrandId !=
                null &&
            !_brands.any(
              (brand) =>
                  brand.id ==
                  _selectedBrandId,
            )) {
          _selectedBrandId = null;
        }

        if (_selectedCategoryId !=
                null &&
            !_categories.any(
              (category) =>
                  category.id ==
                  _selectedCategoryId,
            )) {
          _selectedCategoryId = null;
        }

        _loadingData = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadingData = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _currentPriceController.dispose();
    _oldPriceController.dispose();
    _ratingController.dispose();
    _reviewsController.dispose();
    _stockController.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocListener<
        ProductsCubit,
        ProductsState>(
      listener: (context, state) {
        if (!mounted) {
          return;
        }

        if (state is ProductsSaving) {
          setState(() {
            _saving = true;
          });
        }

        if (state is ProductsError) {
          setState(() {
            _saving = false;
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
              ),
            ),
          );
        }

        if (state is ProductsSuccess) {
          setState(() {
            _saving = false;
          });

          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isEditing
                ? 'Edit Product'
                : 'Add New Product',
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
        body: _loadingData
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder:
          (context, constraints) {
        final width =
            constraints.maxWidth;

        final horizontalPadding =
            width < 600 ? 12.0 : 24.0;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal:
                horizontalPadding,
            vertical: 20,
          ),
          child: Align(
            alignment:
                Alignment.topCenter,
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 900,
              ),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding:
                      EdgeInsets.all(
                    width < 600
                        ? 16
                        : 28,
                  ),
                  child:
                      _buildForm(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          _buildImagePicker(),

          const SizedBox(height: 28),

          _buildSectionTitle(
            'Basic Information',
          ),

          const SizedBox(height: 14),

          CustomTextField(
            controller:
                _nameController,
            label: 'Product Name',
            hintText:
                'Enter product name',
            validator:
                _requiredValidator,
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller:
                _descriptionController,
            label: 'Description',
            hintText:
                'Enter product description',
            validator:
                _requiredValidator,
          ),

          const SizedBox(height: 16),

          _buildBrandDropdown(),

          const SizedBox(height: 16),

          _buildCategoryDropdown(),

          const SizedBox(height: 28),

          _buildSectionTitle(
            'Pricing',
          ),

          const SizedBox(height: 14),

          _buildPriceFields(),

          const SizedBox(height: 28),

          _buildSectionTitle(
            'Statistics',
          ),

          const SizedBox(height: 14),

          _buildStatisticsFields(),

          const SizedBox(height: 28),

          _buildColorsSection(),

          const SizedBox(height: 28),

          _buildSizesSection(),

          const SizedBox(height: 32),

          SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      widget.isEditing
                          ? 'Update Product'
                          : 'Create Product',
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
  ) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight:
            FontWeight.bold,
      ),
    );
  }

  Widget _buildPriceFields() {
    return LayoutBuilder(
      builder:
          (context, constraints) {
        if (constraints.maxWidth <
            600) {
          return Column(
            children: [
              CustomTextField(
                controller:
                    _currentPriceController,
                label:
                    'Current Price',
                hintText: '0.00',
                keyboardType:
                    const TextInputType
                        .numberWithOptions(
                  decimal: true,
                ),
                validator:
                    _numberValidator,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                controller:
                    _oldPriceController,
                label: 'Old Price',
                hintText: '0.00',
                keyboardType:
                    const TextInputType
                        .numberWithOptions(
                  decimal: true,
                ),
                validator:
                    _oldPriceValidator,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child:
                  CustomTextField(
                controller:
                    _currentPriceController,
                label:
                    'Current Price',
                hintText: '0.00',
                keyboardType:
                    const TextInputType
                        .numberWithOptions(
                  decimal: true,
                ),
                validator:
                    _numberValidator,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child:
                  CustomTextField(
                controller:
                    _oldPriceController,
                label: 'Old Price',
                hintText: '0.00',
                keyboardType:
                    const TextInputType
                        .numberWithOptions(
                  decimal: true,
                ),
                validator:
                    _oldPriceValidator,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatisticsFields() {
    return LayoutBuilder(
      builder:
          (context, constraints) {
        if (constraints.maxWidth <
            700) {
          return Column(
            children: [
              CustomTextField(
                controller:
                    _ratingController,
                label: 'Rating',
                hintText: '0 - 5',
                keyboardType:
                    const TextInputType
                        .numberWithOptions(
                  decimal: true,
                ),
                validator:
                    _ratingValidator,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                controller:
                    _reviewsController,
                label:
                    'Reviews Count',
                hintText: '0',
                keyboardType:
                    TextInputType.number,
                validator:
                    _integerValidator,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextField(
                controller:
                    _stockController,
                label:
                    'Stock Quantity',
                hintText: '0',
                keyboardType:
                    TextInputType.number,
                validator:
                    _integerValidator,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child:
                  CustomTextField(
                controller:
                    _ratingController,
                label: 'Rating',
                hintText: '0 - 5',
                keyboardType:
                    const TextInputType
                        .numberWithOptions(
                  decimal: true,
                ),
                validator:
                    _ratingValidator,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child:
                  CustomTextField(
                controller:
                    _reviewsController,
                label:
                    'Reviews Count',
                hintText: '0',
                keyboardType:
                    TextInputType.number,
                validator:
                    _integerValidator,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child:
                  CustomTextField(
                controller:
                    _stockController,
                label:
                    'Stock Quantity',
                hintText: '0',
                keyboardType:
                    TextInputType.number,
                validator:
                    _integerValidator,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Image',
          style: TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 260,
          child: InkWell(
            onTap:
                _saving ? null : _pickImage,
            borderRadius:
                BorderRadius.circular(
              18,
            ),
            child: Container(
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius
                        .circular(18),
                border: Border.all(
                  color: Colors
                      .grey.shade300,
                ),
              ),
              child:
                  _buildImageContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageContent() {
    if (_newImageBytes != null) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        child: Image.memory(
          _newImageBytes!,
          fit: BoxFit.cover,
        ),
      );
    }

    if (_imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        child: Image.network(
          _imageUrl,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error,
                  stackTrace) {
            return const Center(
              child: Icon(
                Icons
                    .broken_image_outlined,
                size: 50,
              ),
            );
          },
        ),
      );
    }

    return const Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            Icons
                .cloud_upload_outlined,
            size: 50,
          ),
          SizedBox(height: 12),
          Text(
            'Click to upload product image',
          ),
        ],
      ),
    );
  }

  Widget _buildBrandDropdown() {
    return DropdownButtonFormField<
        String>(
      initialValue:
          _selectedBrandId,
      isExpanded: true,
      decoration:
          const InputDecoration(
        labelText: 'Brand',
        prefixIcon: Icon(
          Icons
              .branding_watermark_outlined,
        ),
      ),
      items: _brands.map(
        (brand) {
          return DropdownMenuItem<
              String>(
            value: brand.id,
            child: Text(
              brand.name,
              overflow:
                  TextOverflow.ellipsis,
            ),
          );
        },
      ).toList(),
      onChanged: _saving
          ? null
          : (value) {
              setState(() {
                _selectedBrandId =
                    value;
              });
            },
      validator: (value) {
        if (value == null ||
            value.isEmpty) {
          return 'Please select a brand';
        }

        return null;
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<
        String>(
      initialValue:
          _selectedCategoryId,
      isExpanded: true,
      decoration:
          const InputDecoration(
        labelText: 'Category',
        prefixIcon: Icon(
          Icons.category_outlined,
        ),
      ),
      items: _categories.map(
        (category) {
          return DropdownMenuItem<
              String>(
            value: category.id,
            child: Text(
              category.name,
              overflow:
                  TextOverflow.ellipsis,
            ),
          );
        },
      ).toList(),
      onChanged: _saving
          ? null
          : (value) {
              setState(() {
                _selectedCategoryId =
                    value;
              });
            },
      validator: (value) {
        if (value == null ||
            value.isEmpty) {
          return 'Please select a category';
        }

        return null;
      },
    );
  }

  Widget _buildColorsSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment:
              WrapAlignment.spaceBetween,
          crossAxisAlignment:
              WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            const Text(
              'Colors',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            OutlinedButton.icon(
              onPressed:
                  _saving ? null : _addColor,
              icon: const Icon(
                Icons.add,
              ),
              label: const Text(
                'Add Color',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (_colors.isEmpty)
          Text(
            'No colors added.',
            style: TextStyle(
              color:
                  Colors.grey.shade600,
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _colors.map(
              (color) {
                return Chip(
                  avatar:
                      CircleAvatar(
                    backgroundColor:
                        color.colorValue,
                  ),
                  label:
                      Text(color.name),
                  onDeleted: _saving
                      ? null
                      : () {
                          setState(() {
                            _colors.remove(
                              color,
                            );
                          });
                        },
                );
              },
            ).toList(),
          ),
      ],
    );
  }

  Widget _buildSizesSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Sizes',
          style: TextStyle(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              List.generate(
            _sizes.length,
            (index) {
              final size =
                  _sizes[index];

              return FilterChip(
                label:
                    Text(size.label),
                selected:
                    size.isAvailable,
                onSelected: _saving
                    ? null
                    : (selected) {
                        setState(() {
                          _sizes[index] =
                              AdminProductSize(
                            label:
                                size.label,
                            isAvailable:
                                selected,
                          );
                        });
                      },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      final file =
          await _imagePicker.pickImage(
        source:
            ImageSource.gallery,
      );

      if (file == null) {
        return;
      }

      final bytes =
          await file.readAsBytes();

      if (!mounted) {
        return;
      }

      setState(() {
        _newImageBytes = bytes;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> _addColor() async {
    final result =
        await showDialog<AdminProductColor>(
      context: context,
      builder: (_) {
        return const _AddColorDialog();
      },
    );

    if (!mounted ||
        result == null) {
      return;
    }

    setState(() {
      _colors.add(result);
    });
  }

  Future<void> _save() async {
    final isValid =
        _formKey.currentState
                ?.validate() ??
            false;

    if (!isValid) {
      return;
    }

    if (_selectedBrandId ==
            null ||
        _selectedCategoryId ==
            null) {
      return;
    }

    final currentPrice =
        double.tryParse(
      _currentPriceController.text
          .trim(),
    );

    final oldPrice =
        double.tryParse(
      _oldPriceController.text
          .trim(),
    );

    final rating =
        double.tryParse(
      _ratingController.text
          .trim(),
    );

    final reviews =
        int.tryParse(
      _reviewsController.text
          .trim(),
    );

    final stock =
        int.tryParse(
      _stockController.text
          .trim(),
    );

    if (currentPrice == null ||
        oldPrice == null ||
        rating == null ||
        reviews == null ||
        stock == null) {
      return;
    }

    if (oldPrice <
        currentPrice) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Old price must be greater than or equal to current price.',
          ),
        ),
      );

      return;
    }

    String imageUrl =
        _imageUrl;

    try {
      setState(() {
        _saving = true;
      });

      if (_newImageBytes !=
          null) {
        imageUrl =
            await cloudinaryService
                .uploadImage(
          _newImageBytes!,
        );
      }

      if (imageUrl.isEmpty) {
        throw Exception(
          'Please select a product image.',
        );
      }

      final List<String> images =
          List<String>.from(
        widget.product?.images ??
            <String>[],
      );

      if (images.isEmpty) {
        images.add(imageUrl);
      } else if (_newImageBytes !=
          null) {
        images[0] = imageUrl;
      }

      final product =
          AdminProductModel(
        id: widget.product?.id ??
            '',
        name:
            _nameController.text
                .trim(),
        description:
            _descriptionController
                .text
                .trim(),
        brandId:
            _selectedBrandId!,
        categoryId:
            _selectedCategoryId!,
        image: imageUrl,
        images: images,
        currentPrice:
            currentPrice,
        oldPrice: oldPrice,
        rating: rating,
        reviewsCount: reviews,
        stockQuantity: stock,
        colors:
            List<AdminProductColor>.from(
          _colors,
        ),
        sizes:
            List<AdminProductSize>.from(
          _sizes,
        ),
        createdAt:
            widget.product
                ?.createdAt,
      );

      if (!mounted) {
        return;
      }

      final cubit =
          context.read<
              ProductsCubit>();

      if (widget.isEditing) {
        await cubit.updateProduct(
          product,
        );
      } else {
        await cubit.createProduct(
          product,
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  String? _requiredValidator(
    String? value,
  ) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  String? _numberValidator(
    String? value,
  ) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Required';
    }

    if (double.tryParse(
          value.trim(),
        ) ==
        null) {
      return 'Enter a valid number';
    }

    return null;
  }

  String? _integerValidator(
    String? value,
  ) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Required';
    }

    if (int.tryParse(
          value.trim(),
        ) ==
        null) {
      return 'Enter a valid integer';
    }

    return null;
  }

  String? _ratingValidator(
    String? value,
  ) {
    final result =
        _numberValidator(
      value,
    );

    if (result != null) {
      return result;
    }

    final rating =
        double.parse(
      value!.trim(),
    );

    if (rating < 0 ||
        rating > 5) {
      return 'Rating must be between 0 and 5';
    }

    return null;
  }

  String? _oldPriceValidator(
    String? value,
  ) {
    final result =
        _numberValidator(
      value,
    );

    if (result != null) {
      return result;
    }

    final oldPrice =
        double.parse(
      value!.trim(),
    );

    final currentPrice =
        double.tryParse(
      _currentPriceController.text
          .trim(),
    );

    if (currentPrice != null &&
        oldPrice <
            currentPrice) {
      return 'Old price must be >= current price';
    }

    return null;
  }
}

class _AddColorDialog extends StatefulWidget {
  const _AddColorDialog();

  @override
  State<_AddColorDialog> createState() =>
      _AddColorDialogState();
}

class _AddColorDialogState
    extends State<_AddColorDialog> {
  final TextEditingController
      _nameController =
      TextEditingController();

  Color _selectedColor =
      Colors.black;

  final List<Color> _colors = const [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.grey,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.deepOrange,
  ];

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  bool get _isLightColor {
    return _selectedColor ==
            Colors.white ||
        _selectedColor ==
            Colors.yellow;
  }

  void _submit() {
    final name =
        _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter color name.',
          ),
        ),
      );

      return;
    }

    Navigator.of(context).pop(
      AdminProductColor(
        name: name,
        colorValue: _selectedColor,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text(
        'Add Color',
      ),
      content:
          SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            TextField(
              controller:
                  _nameController,
              autofocus: true,
              decoration:
                  const InputDecoration(
                labelText:
                    'Color Name',
                hintText:
                    'Example: Black',
                border:
                    OutlineInputBorder(),
              ),
              textInputAction:
                  TextInputAction.done,
              onSubmitted: (_) {
                _submit();
              },
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              'Choose Color',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  _colors.map(
                (color) {
                  final isSelected =
                      _selectedColor ==
                          color;

                  final isLight =
                      color ==
                              Colors.white ||
                          color ==
                              Colors.yellow;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedColor =
                            color;
                      });
                    },
                    borderRadius:
                        BorderRadius
                            .circular(
                      30,
                    ),
                    child:
                        Container(
                      width: 44,
                      height: 44,
                      decoration:
                          BoxDecoration(
                        color: color,
                        shape:
                            BoxShape
                                .circle,
                        border:
                            Border.all(
                          color:
                              isSelected
                                  ? Colors
                                      .blue
                                  : Colors
                                      .grey
                                      .shade300,
                          width:
                              isSelected
                                  ? 3
                                  : 1,
                        ),
                      ),
                      child:
                          isSelected
                              ? Icon(
                                  Icons
                                      .check,
                                  size:
                                      21,
                                  color:
                                      isLight
                                          ? Colors
                                              .black
                                          : Colors
                                              .white,
                                )
                              : null,
                    ),
                  );
                },
              ).toList(),
            ),

            const SizedBox(
              height: 20,
            ),

            Row(
              children: [
                const Text(
                  'Selected:',
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                Container(
                  width: 30,
                  height: 30,
                  decoration:
                      BoxDecoration(
                    color:
                        _selectedColor,
                    shape:
                        BoxShape.circle,
                    border:
                        Border.all(
                      color: Colors
                          .grey
                          .shade400,
                    ),
                  ),
                  child:
                      _isLightColor
                          ? const Icon(
                              Icons
                                  .check,
                              size: 16,
                              color: Colors
                                  .black,
                            )
                          : const Icon(
                              Icons
                                  .check,
                              size: 16,
                              color: Colors
                                  .white,
                            ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop();
          },
          child: const Text(
            'Cancel',
          ),
        ),

        FilledButton(
          onPressed: _submit,
          child: const Text(
            'Add',
          ),
        ),
      ],
    );
  }
}
