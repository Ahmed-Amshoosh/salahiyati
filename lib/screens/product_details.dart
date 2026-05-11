import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                                const Text(
                                  'حليب كامل الدسم',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Center(
                                  child: const Text(
                                    'ألبان',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,fontWeight:FontWeight.bold 
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
                                    color: const Color(
                                      0xFF0B8F4D,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(25),
                                  ),

                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 18,
                                        color: Color(0xFF0B8F4D),
                                      ),

                                      SizedBox(width: 8),

                                      Text(
                                        'ينتهي خلال 3 أيام',
                                        style: TextStyle(
                                          color: Color(0xFF0B8F4D),
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
                                'https://via.placeholder.com/300x300/4A90E2/FFFFFF?text=حليب',
                                fit: BoxFit.contain,

                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade100,
                                    child: const Icon(
                                      Icons.local_drink,
                                      size: 70,
                                      color: Colors.blue,
                                    ),
                                  );
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
                            value: '2024 مايو 20',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.add_box_outlined,
                            label: 'تاريخ الإضافة',
                            value: '2024 مايو 10',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.straighten_outlined,
                            label: 'الكمية / الحجم',
                            value: '1 لتر',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.store_outlined,
                            label: 'الماركة',
                            value: 'المراعي',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.location_on_outlined,
                            label: 'الموقع',
                            value: 'الثلاجة - الرف العلوي',
                          ),
                          _buildDivider(),
                          _buildDetailRow(
                            icon: Icons.note_outlined,
                            label: 'ملاحظات',
                            value: 'لا توجد ملاحظات',
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
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Edit Button
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF0B8F4D),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFF0B8F4D),
                          size: 22,
                        ),
                        label: const Text(
                          'تعديل',
                          style: TextStyle(
                            color: Color(0xFF0B8F4D),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Delete Button
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextButton.icon(
                        onPressed: () {
                          _showDeleteConfirmation(context);
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.shade600,
                          size: 22,
                        ),
                        label: Text(
                          'حذف',
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
