import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/dummy_data.dart';

/// Halaman bantuan, FAQ, dan informasi toko
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Toko
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('🍩', style: TextStyle(fontSize: 28)),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DRS - Donat Reinhard Samuel',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            'Donat Manis, Lembut, dan Selalu Fresh',
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _StoreInfo(icon: Icons.location_on_rounded, text: 'Jl. Bakery Central No. 1, Jakarta Selatan'),
                  const SizedBox(height: 6),
                  const _StoreInfo(icon: Icons.access_time_rounded, text: 'Buka: Senin - Minggu, 07.00 - 21.00 WIB'),
                  const SizedBox(height: 6),
                  const _StoreInfo(icon: Icons.local_shipping_rounded, text: 'Ongkos kirim: Rp 10.000 (area sekitar toko)'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Hubungi Kami
            const Text(
              'Hubungi Kami',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            _ContactCard(
              icon: Icons.chat_rounded,
              title: 'WhatsApp',
              subtitle: 'Chat langsung dengan admin',
              color: const Color(0xFF25D366),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('WhatsApp: 0812-3456-7890 - Buka aplikasi WhatsApp untuk chat')),
                );
              },
            ),
            _ContactCard(
              icon: Icons.map_rounded,
              title: 'Alamat Toko',
              subtitle: 'Jl. Bakery Central No. 1, Jakarta Selatan',
              color: AppColors.primary,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alamat: Jl. Bakery Central No. 1, Jakarta Selatan')),
                );
              },
            ),

            const SizedBox(height: 20),

            // FAQ
            const Text(
              'Pertanyaan Umum (FAQ)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            ...DummyData.faqs.map((faq) => _FAQItem(
              question: faq['q']!,
              answer: faq['a']!,
            )),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StoreInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _StoreInfo({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.softShadow,
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
        trailing: const Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.textHint),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  // ignore: unused_field
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.softShadow,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            widget.question,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          leading: const Icon(Icons.help_outline_rounded, color: AppColors.primary, size: 20),
          iconColor: AppColors.primary,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                widget.answer,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
