import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int getDaysLeft(String expiryDate) {
    try {
      final expiry = DateTime.parse(expiryDate);

      final now = DateTime.now();

      // مهم: نقارن بدون وقت (فقط تاريخ)
      final today = DateTime(now.year, now.month, now.day);
      final exp = DateTime(expiry.year, expiry.month, expiry.day);

      return exp.difference(today).inDays;
    } catch (e) {
      return 999;
    }
  }

  Color getStatusColor(int daysLeft) {
    if (daysLeft < 0) return Colors.red;
    if (daysLeft <= 3) return Colors.orange;
    return const Color(0xFF0B8F4D);
  }

  String formatDate(dynamic timestamp) {
    if (timestamp == null) return '';
    try {
      final date = timestamp.toDate();
      return "${date.year}-${date.month}-${date.day}";
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = getDaysLeft(widget.product['expirationDate'] ?? "");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'تفاصيل المنتج',
          style: TextStyle(
            color: Color(0xFF0B8F4D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.black87),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Product Image and Info Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 🔹 المحتوى (يمين)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product['name'] ?? '',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Center(
                                  child: Text(
                                    widget.product['category'] ?? '',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                /// حالة الانتهاء
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(daysLeft).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(25),
                                  ),

                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                       Icon(
                                        Icons.access_time,
                                        size: 18,
                                        color: getStatusColor(daysLeft),
                                      ),

                                      const SizedBox(width: 8),

                                      Text(
                                        daysLeft < 0
                                            ? 'منتهي منذ ${daysLeft.abs()} يوم'
                                            : daysLeft == 0
                                            ? 'ينتهي اليوم'
                                            : 'ينتهي خلال $daysLeft أيام',
                                        style:  TextStyle(
                                          color: getStatusColor(daysLeft),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          /// 🔹 الصورة (يسار)
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),

                              child: Image.network(
                                widget.product['imageUrl'] ?? '',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Details Section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'تاريخ الانتهاء',
                            value: widget.product['expirationDate'] ?? '',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.add_box_outlined,
                            label: 'تاريخ الإضافة',
                            value: formatDate(widget.product['createdAt']),
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.straighten_outlined,
                            label: 'الكمية / الحجم',
                            value: widget.product['quantity'] ?? '',
                          ),

                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.note_outlined,
                            label: 'ملاحظات',
                            value: widget.product['notes']?.isNotEmpty == true
                                ? widget.product['notes']
                                : 'لا توجد ملاحظات',
                            valueColor: Colors.grey,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 🔹 الليبل (يمين)
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// 🔹 القيمة + الأيقونة (يسار)
          Row(
            children: [
              Text(
                value,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Colors.black87,
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 20,
      endIndent: 20,
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.red.shade600, size: 28),
              const SizedBox(width: 12),
              const Text(
                'تأكيد الحذف',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'هل أنت متأكد من رغبتك في حذف هذا المنتج؟',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Perform delete action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حذف المنتج بنجاح'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }
}
