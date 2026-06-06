import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/product_model.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/primary_button.dart';

const _uuid = Uuid();

/// Halaman tambah / edit produk untuk admin
class AdminAddEditProductScreen extends ConsumerStatefulWidget {
  const AdminAddEditProductScreen({super.key});

  @override
  ConsumerState<AdminAddEditProductScreen> createState() => _AdminAddEditProductScreenState();
}

class _AdminAddEditProductScreenState extends ConsumerState<AdminAddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _compositionCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  String _selectedCategory = AppStrings.catChocolate;
  bool _isAvailable = true;
  bool _isLoading = false;

  ProductModel? _existingProduct;
  bool get _isEditing => _existingProduct != null;

  final List<String> _categories = const [
    AppStrings.catChocolate,
    AppStrings.catCheese,
    AppStrings.catGlaze,
    AppStrings.catPremium,
    AppStrings.catBundle,
    AppStrings.catDrink,
  ];

  final List<String> _emojiOptions = ['🍩', '🧀', '🍓', '🍵', '☕', '🍪', '🔴', '📦', '🎁', '🧋', '🍫', '🍋', '🍯', '⚪'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final product = ModalRoute.of(context)?.settings.arguments as ProductModel?;
    if (product != null && _existingProduct == null) {
      _existingProduct = product;
      _nameCtrl.text = product.name;
      _priceCtrl.text = product.price.toString();
      _descCtrl.text = product.description;
      _compositionCtrl.text = product.composition;
      _stockCtrl.text = product.stock.toString();
      _imageCtrl.text = product.imageUrl;
      _selectedCategory = product.category;
      _isAvailable = product.isAvailable;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _compositionCtrl.dispose();
    _stockCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final product = ProductModel(
      id: _existingProduct?.id ?? 'p${_uuid.v4().substring(0, 8)}',
      name: _nameCtrl.text.trim(),
      category: _selectedCategory,
      price: int.tryParse(_priceCtrl.text.trim()) ?? 0,
      description: _descCtrl.text.trim(),
      composition: _compositionCtrl.text.trim(),
      imageUrl: _imageCtrl.text.trim(),
      rating: _existingProduct?.rating ?? 0.0,
      reviewCount: _existingProduct?.reviewCount ?? 0,
      soldCount: _existingProduct?.soldCount ?? 0,
      stock: int.tryParse(_stockCtrl.text.trim()) ?? 0,
      isAvailable: _isAvailable,
    );

    if (_isEditing) {
      await ref.read(productProvider.notifier).updateProduct(product);
    } else {
      await ref.read(productProvider.notifier).addProduct(product);
    }

    setState(() => _isLoading = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Produk berhasil diperbarui ✅' : 'Produk berhasil ditambahkan ✅')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Produk' : 'Tambah Produk'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Preview emoji
            Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: Text(
                        _imageCtrl.text.isNotEmpty ? _imageCtrl.text : '🍩',
                        style: const TextStyle(fontSize: 52),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Pilih emoji produk:', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _emojiOptions.map((emoji) {
                      final isSelected = _imageCtrl.text == emoji;
                      return GestureDetector(
                        onTap: () => setState(() => _imageCtrl.text = emoji),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                            border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                          ),
                          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            CustomTextField(
              label: 'Nama Produk',
              controller: _nameCtrl,
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),

            // Kategori
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kategori', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(),
                  items: _categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v!),
                ),
              ],
            ),
            const SizedBox(height: 12),

            CustomTextField(
              label: 'Harga (Rp)',
              hint: 'Contoh: 8000',
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Wajib diisi';
                if (int.tryParse(v) == null) return 'Masukkan angka yang valid';
                return null;
              },
            ),
            const SizedBox(height: 12),

            CustomTextField(
              label: 'Stok',
              hint: 'Jumlah stok tersedia',
              controller: _stockCtrl,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Wajib diisi';
                if (int.tryParse(v) == null) return 'Masukkan angka yang valid';
                return null;
              },
            ),
            const SizedBox(height: 12),

            CustomTextField(
              label: 'Deskripsi',
              hint: 'Deskripsi produk...',
              controller: _descCtrl,
              maxLines: 3,
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 12),

            CustomTextField(
              label: 'Komposisi (opsional)',
              hint: 'Bahan-bahan produk',
              controller: _compositionCtrl,
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Toggle tersedia
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppColors.softShadow,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status Produk', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        Text('Produk akan tampil di katalog', style: TextStyle(fontSize: 12, color: AppColors.textHint)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isAvailable,
                    onChanged: (v) => setState(() => _isAvailable = v),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            PrimaryButton(
              label: _isEditing ? 'Simpan Perubahan' : 'Tambahkan Produk',
              onPressed: _save,
              isLoading: _isLoading,
              icon: Icons.save_rounded,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
