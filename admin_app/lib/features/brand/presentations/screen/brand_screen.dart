import 'package:e_commerce_admin/core/styling/appcolors.dart';
import 'package:e_commerce_admin/features/brand/data/models/brand_model.dart';
import 'package:e_commerce_admin/features/brand/presentations/cubit/brand_cubit.dart';
import 'package:e_commerce_admin/features/brand/presentations/cubit/brand_state.dart';
import 'package:e_commerce_admin/features/brand/presentations/screen/add_edit_brand.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BrandCubit>().getAllBrands();
  }

  Future<void> _deleteBrand(
    AdminBrandModel brand,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Brand'),
          content: Text(
            'Are you sure you want to delete "${brand.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await context.read<BrandCubit>().deleteBrand(
          brand.id,
        );
  }

  Future<void> _openAddBrand() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEditBrandScreen(),
      ),
    );

    if (mounted) {
      context.read<BrandCubit>().getAllBrands();
    }
  }

  Future<void> _openEditBrand(
    AdminBrandModel brand,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditBrandScreen(
          brand: brand,
        ),
      ),
    );

    if (mounted) {
      context.read<BrandCubit>().getAllBrands();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Brands',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<BrandCubit, BrandState>(
        builder: (context, state) {
          if (state is BrandLoading ||
              state is BrandInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is BrandError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<BrandCubit>()
                            .getAllBrands();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          List<AdminBrandModel> brands = [];

          if (state is BrandSuccess) {
            brands = state.brands;
          } else if (state is BrandSaving) {
            brands = state.brands;
          } else if (state is BrandDeleting) {
            brands = state.brands;
          }

          if (brands.isEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  const Icon(
                    Icons.branding_watermark_outlined,
                    size: 70,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No brands found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _AddBrandButton(
                    onPressed: _openAddBrand,
                  ),
                ],
              ),
            );
          }

          final isDeleting = state is BrandDeleting;

          return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;

              if (constraints.maxWidth >= 1200) {
                crossAxisCount = 5;
              } else if (constraints.maxWidth >= 800) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth >= 600) {
                crossAxisCount = 3;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.95,
                      ),
                      itemCount: brands.length,
                      itemBuilder: (context, index) {
                        final brand = brands[index];

                        final deleting =
                            isDeleting &&
                            state.brandId == brand.id;

                        return Card(
                          elevation: 2,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.all(20),
                                  color: Colors.white,
                                  child: brand.image.isNotEmpty
                                      ? Image.network(
                                          brand.image,
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
                                              size: 60,
                                            );
                                          },
                                        )
                                      : const Icon(
                                          Icons
                                              .branding_watermark_outlined,
                                          size: 60,
                                        ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                child: Text(
                                  brand.name,
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(
                                  8,
                                  0,
                                  8,
                                  10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      tooltip: 'Edit',
                                      onPressed: deleting
                                          ? null
                                          : () =>
                                              _openEditBrand(
                                                brand,
                                              ),
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Delete',
                                      onPressed: deleting
                                          ? null
                                          : () => _deleteBrand(
                                              brand,
                                            ),
                                      icon: deleting
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(
                                              Icons
                                                  .delete_outline,
                                              color: Colors.red,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    _AddBrandButton(
                      onPressed: _openAddBrand,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AddBrandButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddBrandButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Brand',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}