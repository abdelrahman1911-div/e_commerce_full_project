import 'package:e_commerce_admin/features/product/data/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductCardWidget extends StatelessWidget {
  final AdminProductModel product;
  final String? brandName;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.brandName,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // PRODUCT IMAGE
          // =========================================================

          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 50,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                    loadingBuilder: (
                      context,
                      child,
                      loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Container(
                        color: colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    },
                  ),
                ),

                // Discount
                if (product.discount.isNotEmpty)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.discount,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onError,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // =========================================================
          // PRODUCT INFO
          // =========================================================

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  brandName ?? product.brandId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 10),

                // =====================================================
                // RATING
                // =====================================================

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 17,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${product.reviewsCount})',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // =====================================================
                // PRICE
                // =====================================================

                Row(
                  children: [
                    Text(
                      product.currentPrice.toString(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 8),

                    if (product.oldPrice > product.currentPrice)
                      Text(
                        product.oldPrice.toString(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 14),

                // =====================================================
                // ACTIONS
                // =====================================================

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                        ),
                        label: const Text('Edit'),
                      ),
                    ),

                    const SizedBox(width: 8),

                    IconButton(
                      onPressed: onDelete,
                      tooltip: 'Delete product',
                      style: IconButton.styleFrom(
                        backgroundColor:
                            colorScheme.error.withValues(alpha: 0.10),
                        foregroundColor: colorScheme.error,
                      ),
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}