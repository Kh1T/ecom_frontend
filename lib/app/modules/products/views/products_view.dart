import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        child: ListTile(
                          leading: const Icon(Icons.inventory_2),
                          title: Text(product.name),
                          subtitle: Text(
                            '${product.category} · Stock: ${product.stock} · ${product.status}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showProductDialog(
                                  context,
                                  product: product,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => controller.deleteProduct(product.id),
                              ),
                            ],
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
    );
  }

  void _showProductDialog(BuildContext context, {Product? product}) {
    final isEdit = product != null;
    final nameController = TextEditingController(text: product?.name ?? '');
    final categoryController = TextEditingController(text: product?.category ?? '');
    final priceController = TextEditingController(
      text: product != null ? product.price.toString() : '',
    );
    final stockController = TextEditingController(
      text: product != null ? product.stock.toString() : '',
    );

    Get.defaultDialog(
      title: isEdit ? 'Edit Product' : 'Add Product',
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
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
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      textConfirm: isEdit ? 'Update' : 'Create',
      textCancel: 'Cancel',
      onConfirm: () {
        final data = {
          'name': nameController.text,
          'category': categoryController.text,
          'price': double.tryParse(priceController.text) ?? 0,
          'stock': int.tryParse(stockController.text) ?? 0,
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
