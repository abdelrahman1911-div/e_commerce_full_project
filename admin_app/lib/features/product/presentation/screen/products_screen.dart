import 'package:e_commerce_admin/core/router/app_routes.dart';
import 'package:e_commerce_admin/features/product/data/model/product_model.dart';
import 'package:e_commerce_admin/features/product/presentation/cubit/prod_cubit.dart';
import 'package:e_commerce_admin/features/product/presentation/cubit/prod_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductsScreen
    extends StatefulWidget {
  const ProductsScreen({
    super.key,
  });

  @override
  State<ProductsScreen> createState() =>
      _ProductsScreenState();
}

class _ProductsScreenState
    extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      context
          .read<ProductsCubit>()
          .getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocConsumer<
          ProductsCubit,
          ProductsState>(
        listener: (context, state) {
          if (state is ProductsError) {
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar();

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
                behavior:
                    SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }
          if (state is ProductsDeleting) {
            return _ProductsContent(
              products: state.products,
              deletingId:
                  state.productId,
              loading: true,
            );
          }
          if (state is ProductsSaving) {
            return _ProductsContent(
              products: state.products,
              deletingId: null,
              loading: true,
            );
          }
          if (state is ProductsSuccess) {
            return _ProductsContent(
              products: state.products,
              deletingId: null,
              loading: false,
            );
          } 
          if (state is ProductsError) {
            return _ErrorView(
              message: state.message,
              retry: () {
                context
                    .read<ProductsCubit>()
                    .getAllProducts();
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
class _ProductsContent
    extends StatelessWidget {
  final List<AdminProductModel> products;
  final String? deletingId;
  final bool loading;

  const _ProductsContent({
    required this.products,
    required this.deletingId,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: products.isEmpty
              ? const Center(
                  child: Text(
                    'No products found',
                  ),
                )
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(24),
                  child: _ProductsTable(
                    products: products,
                    deletingId: deletingId,
                    loading: loading,
                  ),
                ),
        ),
        Padding(
          padding:
              const EdgeInsets.fromLTRB(
            24,
            12,
            24,
            24,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: loading
                  ? null
                  : () {
                      context.push(
                        AppRoutes.createProduct,
                      );
                    },
              icon: const Icon(
                Icons.add_box_outlined,
              ),
              label: const Text(
                'Add New Product',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductsTable
    extends StatelessWidget {
  final List<AdminProductModel> products;
  final String? deletingId;
  final bool loading;

  const _ProductsTable({
    required this.products,
    required this.deletingId,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 28,
            columns: const [
              DataColumn(
                label: Text('Image'),
              ),
              DataColumn(
                label: Text('Name'),
              ),
              DataColumn(
                label: Text('Brand'),
              ),
              DataColumn(
                label: Text('Category'),
              ),
              DataColumn(
                label: Text('Current Price'),
              ),
              DataColumn(
                label: Text('Old Price'),
              ),
              DataColumn(
                label: Text('Discount'),
              ),
              DataColumn(
                label: Text('Rating'),
              ),
              DataColumn(
                label: Text('Reviews'),
              ),
              DataColumn(
                label: Text('Stock'),
              ),
              DataColumn(
                label: Text('Action'),
              ),
            ],
            rows: products.map(
              (product) {
                final deleting =
                    deletingId == product.id;

                return DataRow(
                  cells: [
                    DataCell(
                      _ProductImage(
                        url: product.image,
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 180,
                        child: Text(
                          product.name,
                          overflow:
                              TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                         product.brandName,
                      ),
                    ),
                    DataCell(
                      Text(
                        product.categoryName.isEmpty
                            ? product.categoryId
                            : product.categoryName,
                      ),
                    ),
                    DataCell(
                      Text(
                        product.currentPrice
                            .toStringAsFixed(2),
                      ),
                    ),
                    DataCell(
                      Text(
                        product.oldPrice
                            .toStringAsFixed(2),
                      ),
                    ),
                    DataCell(
                      Text(
                        product.discount,
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.rating
                                .toStringAsFixed(1),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Text(
                        product.reviewsCount
                            .toString(),
                      ),
                    ),
                    DataCell(
                      Text(
                        product.stockQuantity
                            .toString(),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Edit',
                            onPressed: loading
                                ? null
                                : () {
                                    context.push(
                                      AppRoutes
                                          .editProduct,
                                      extra: product,
                                    );
                                  },
                            icon: const Icon(
                              Icons.edit_outlined,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: loading
                                ? null
                                : () {
                                    _delete(
                                      context,
                                      product,
                                    );
                                  },
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
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  void _delete(
    BuildContext context,
    AdminProductModel product,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text('Delete Product'),
          content: Text(
            'Are you sure you want to delete '
            '${product.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                dialogContext,
              ),
              child:
                  const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                context
                    .read<ProductsCubit>()
                    .deleteProduct(
                      product.id,
                    );
              },
              child:
                  const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _ProductImage
    extends StatelessWidget {
  final String url;

  const _ProductImage({
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const SizedBox(
        width: 55,
        height: 55,
        child: Icon(
          Icons.image_outlined,
        ),
      );
    }

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(10),
      child: Image.network(
        url,
        width: 55,
        height: 55,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) {
          return const SizedBox(
            width: 55,
            height: 55,
            child: Icon(
              Icons.broken_image_outlined,
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView
    extends StatelessWidget {
  final String message;
  final VoidCallback retry;

  const _ErrorView({
    required this.message,
    required this.retry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign:
                TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: retry,
            child:
                const Text('Retry'),
          ),
        ],
      ),
    );
  }
}