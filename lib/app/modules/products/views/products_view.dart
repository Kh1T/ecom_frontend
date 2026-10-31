import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/sidebar/sidebar.dart';
import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ElevatedButton.icon(
                  onPressed: () => _showProductDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(
              () => Wrap(
                spacing: 8,
                children: [
                  for (final category in controller.categories)
                    ChoiceChip(
                      label: Text(category),
                      selected: controller.selectedCategory.value == category,
                      onSelected: (_) => controller.filterByCategory(category),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.filteredProducts.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }
                  return RefreshIndicator(
                    onRefresh: controller.fetchProducts,
                    child: ListView.builder(
                      itemCount: controller.filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = controller.filteredProducts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 1.5,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _showProductDetails(context, product),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  _buildProductThumbnail(product),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Wrap(
                                          spacing: 6,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.indigo.shade50,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                product.category,
                                                style: TextStyle(
                                                  color: Colors.indigo.shade800,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            if (product.sku != null &&
                                                product.sku!.isNotEmpty)
                                              Text(
                                                'SKU: ${product.sku}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            Text(
                                              'Stock: ${product.stockQuantity}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (product.description != null &&
                                            product.description!.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            product.description!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add_photo_alternate,
                                              size: 20,
                                            ),
                                            tooltip: 'Upload Image',
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () => controller
                                                .pickAndUploadProductImage(
                                              product.id,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () => _showProductDialog(
                                              context,
                                              product: product,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 20,
                                            ),
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () => controller
                                                .deleteProduct(product.id),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductThumbnail(Product product) {
    final hasImage =
        product.firstImageUrl != null && product.firstImageUrl!.isNotEmpty;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 64,
            height: 64,
            color: Colors.grey.shade100,
            child: hasImage
                ? Image.network(
                    product.firstImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
          ),
        ),
        if (product.imageUrls.length > 1)
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${product.imageUrls.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (product.imageUrls.isNotEmpty) ...[
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: product.imageUrls.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, i) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.imageUrls[i],
                              fit: BoxFit.cover,
                              width: 180,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 180,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'Stock: ${product.stockQuantity}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Category: ${product.category}'),
                  if (product.sku != null && product.sku!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('SKU: ${product.sku}'),
                  ],
                  if (product.description != null &&
                      product.description!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Description:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(product.description!),
                  ],
                  const SizedBox(height: 16),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Get.back();
                        await controller.pickAndUploadProductImage(product.id);
                      },
                      icon: const Icon(Icons.add_photo_alternate, size: 18),
                      label: const Text('Upload New Image'),
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

  void _showProductDialog(BuildContext context, {Product? product}) {
    final isEdit = product != null;
    final nameController = TextEditingController(text: product?.name ?? '');
    final categoryController =
        TextEditingController(text: product?.category ?? '');
    final priceController = TextEditingController(
      text: product != null ? product.price.toString() : '',
    );
    final stockController = TextEditingController(
      text: product != null ? product.stockQuantity.toString() : '',
    );
    final skuController = TextEditingController(text: product?.sku ?? '');
    final descriptionController =
        TextEditingController(text: product?.description ?? '');
    final imageUrlsController = TextEditingController(
      text: product != null ? product.imageUrls.join(', ') : '',
    );

    Get.defaultDialog(
      title: isEdit ? 'Edit Product' : 'Add Product',
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: skuController,
                decoration: const InputDecoration(labelText: 'SKU (Optional)'),
              ),
              TextField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 2,
              ),
              TextField(
                controller: imageUrlsController,
                decoration: const InputDecoration(
                  labelText: 'Image URLs (comma-separated)',
                  hintText: 'https://..., https://...',
                ),
              ),
            ],
          ),
        ),
      ),
      textConfirm: isEdit ? 'Update' : 'Create',
      textCancel: 'Cancel',
      onConfirm: () {
        final parsedImages = imageUrlsController.text
            .split(',')
            .map((url) => url.trim())
            .where((url) => url.isNotEmpty)
            .toList();

        final data = {
          'name': nameController.text,
          'category': categoryController.text,
          'price': double.tryParse(priceController.text) ?? 0,
          'stockQuantity': int.tryParse(stockController.text) ?? 0,
          'stock': int.tryParse(stockController.text) ?? 0,
          if (skuController.text.isNotEmpty) 'sku': skuController.text,
          if (descriptionController.text.isNotEmpty)
            'description': descriptionController.text,
          'imageUrls': parsedImages,
        };

        if (isEdit) {
          controller.updateProduct(product.id, data);
        } else {
          controller.createProduct(data);
        }
        Get.back();
      },
    );
  }
}
