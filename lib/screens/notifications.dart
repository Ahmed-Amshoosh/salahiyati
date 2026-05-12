import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  final String initialFilter;
  const NotificationsScreen({
    super.key,
    this.initialFilter = "all",
  });
  

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List notifications = [];
  String selectedFilter = "all";
  
  @override
  void initState() {
    super.initState();
    loadNotifications();
    selectedFilter = widget.initialFilter;
  }

Future<void> loadNotifications() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('products')
      .get();

  List temp = [];

  for (var doc in snapshot.docs) {
    final data = doc.data();

    final daysLeft = getDaysLeft(data['expirationDate'] ?? "");

    /// ✅ نخلي كل المنتجات (منتهية + قريبة)
    if (daysLeft <= 30) {
      temp.add({...data, "daysLeft": daysLeft});
    }
  }

  setState(() {
    notifications = temp;
  });
}
  @override
  Widget build(BuildContext context) {
    notifications.sort((a, b) {
      final aDays = getDaysLeft(a['expirationDate'] ?? "");

      final bDays = getDaysLeft(b['expirationDate'] ?? "");

      return aDays.compareTo(bDays);
    });
    List filteredNotifications = notifications.where((product) {
      final daysLeft = getDaysLeft(product['expirationDate'] ?? "");

      if (selectedFilter == "all") {
        return true;
      }

      if (selectedFilter == "urgent") {
        return daysLeft < 0 || daysLeft <= 3;
      }

      if (selectedFilter == "close") {
        return daysLeft > 3 && daysLeft <= 7;
      }

      return true;
    }).toList();
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'التنبيهات',
          style: TextStyle(
            color: Color(0xFF0B8F4D),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF0B8F4D)),
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // Filter Tabs
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  /// =======================
                  /// الكل
                  /// =======================
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = "all";
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedFilter == "all"
                              ? const Color(0xFF0B8F4D)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'الكل',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: selectedFilter == "all"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// =======================
                  /// عاجلة
                  /// =======================
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = "urgent";
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedFilter == "urgent"
                              ? Colors.red
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// عداد
                            const SizedBox(width: 6),

                            Text(
                              'عاجلة',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: selectedFilter == "urgent"
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// =======================
                  /// قريب
                  /// =======================
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = "close";
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedFilter == "close"
                              ? Colors.orange
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'قريباً',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: selectedFilter == "close"
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: notifications.isEmpty
                  ? const Center(child: Text("لا توجد تنبيهات"))
                  : ListView.builder(
                      itemCount: filteredNotifications.length,

                      itemBuilder: (context, index) {
                        final product = filteredNotifications[index];

                        final daysLeft = getDaysLeft(
                          product['expirationDate'] ?? "",
                        );

                        return _buildNotificationItem(
                          icon: getCategoryIcon(product['category']),

                          iconColor: getCategoryColor(product['category']),

                          title: product['name'] ?? "منتج بدون اسم",

                          subtitle: daysLeft < 0
                              ? "منتهي منذ ${daysLeft.abs()} يوم"
                              : daysLeft == 0
                              ? "ينتهي اليوم"
                              : daysLeft <= 3
                              ? "ينتهي خلال $daysLeft أيام"
                              : daysLeft <= 7
                              ? "قريب الانتهاء خلال $daysLeft أيام"
                              : "متبقي $daysLeft يوم",

                          date: product['expirationDate'] ?? "",

                          time: formatTime(product['createdAt']),

                          alertType: getAlertType(daysLeft),

                          showDate: true,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getCategoryIcon(String? category) {
    switch (category) {
      case "ألبان":
        return Icons.water_drop;

      case "مشروبات":
        return Icons.local_drink;

      case "معلبات":
        return Icons.inventory_2;

      case "وجبات":
        return Icons.fastfood;

      case "حلويات":
        return Icons.cake;

      case "أدوية":
        return Icons.medication;

      case "أرز":
        return Icons.grain;

      default:
        return Icons.shopping_bag;
    }
  }

  /// =======================================
  /// لون حسب الفئة
  /// =======================================

  Color getCategoryColor(String? category) {
    switch (category) {
      case "ألبان":
        return Colors.blue;

      case "مشروبات":
        return Colors.cyan;

      case "معلبات":
        return Colors.orange;

      case "وجبات":
        return Colors.red;

      case "حلويات":
        return Colors.pink;

      case "أدوية":
        return Colors.green;

      case "أرز":
        return Colors.brown;

      default:
        return Colors.grey;
    }
  }

  /// =======================================
  /// تنسيق الوقت
  /// =======================================

  String formatTime(dynamic createdAt) {
    if (createdAt == null) return "";

    try {
      final date = createdAt.toDate();

      return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "";
    }
  }

  /// =======================================
  /// حساب الأيام المتبقية
  /// =======================================
  ///

  int getDaysLeft(String expiryDate) {
    try {
      final expiry = DateTime.parse(expiryDate);

      final now = DateTime.now();

      return expiry.difference(now).inDays;
    } catch (e) {
      return 999;
    }
  }

  AlertType getAlertType(int daysLeft) {
    if (daysLeft < 0) {
      return AlertType.urgent;
    } else if (daysLeft <= 3) {
      return AlertType.warning;
    } else if (daysLeft <= 7) {
      return AlertType.normal;
    } else {
      return AlertType.success;
    }
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String date,
    required String time,
    required AlertType alertType,
    bool showDate = true,
  }) {
    IconData alertIcon;
    Color alertColor;

    switch (alertType) {
      case AlertType.urgent:
        alertIcon = Icons.warning_rounded;
        alertColor = Colors.red;
        break;
      case AlertType.warning:
        alertIcon = Icons.warning_amber_rounded;
        alertColor = Colors.orange;
        break;
      case AlertType.normal:
        alertIcon = Icons.notifications_none;
        alertColor = Colors.orange.shade300;
        break;
      case AlertType.success:
        alertIcon = Icons.check_circle;
        alertColor = Colors.green;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: alertType == AlertType.urgent
                        ? Colors.red
                        : alertType == AlertType.warning
                        ? Colors.orange
                        : Colors.grey,
                    fontSize: 13,
                  ),
                ),
                if (showDate) ...[
                  const SizedBox(height: 3),
                  Text(
                    date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(alertIcon, color: alertColor, size: 24),
              const SizedBox(height: 5),
              Text(
                time,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum AlertType { urgent, warning, normal, success }
