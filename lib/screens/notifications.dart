import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                   Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B8F4D),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'الكل',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
               
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'عاجلة',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                                   Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'قريباً',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  

                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: const Text(
                        'اليوم',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    
                    // Notification Items
                    _buildNotificationItem(
                      icon: Icons.water_drop,
                      iconColor: Colors.blue,
                      title: 'حليب كامل الدسم',
                      subtitle: 'ينتهي خلال 3 أيام',
                      date: '2024 مايو 20',
                      time: '9:30 ص',
                      alertType: AlertType.urgent,
                    ),
                    
                    _buildNotificationItem(
                      icon: Icons.fastfood,
                      iconColor: Colors.orange,
                      title: 'جبنة شيدر',
                      subtitle: 'ينتهي خلال 7 أيام',
                      date: '2024 مايو 24',
                      time: '8:15 ص',
                      alertType: AlertType.warning,
                    ),
                    
                    _buildNotificationItem(
                      icon: Icons.inventory_2,
                      iconColor: Colors.red,
                      title: 'صلصة طماطم',
                      subtitle: 'ينتهي خلال 12 يوم',
                      date: '2024 مايو 29',
                      time: '7:45 ص',
                      alertType: AlertType.normal,
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: const Text(
                        'الأسبوع الماضي',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    
                    _buildNotificationItem(
                      icon: Icons.grain,
                      iconColor: Colors.brown,
                      title: 'أرز بسمتي',
                      subtitle: 'ينتهي خلال 45 يوم',
                      date: '2024 يوليو 01',
                      time: 'مايو 15',
                      alertType: AlertType.success,
                      showDate: false,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Refresh Button
                    Center(
                      child: TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.refresh, color: Color(0xFF0B8F4D)),
                        label: const Text(
                          'تحديث الكل كمقروء',
                          style: TextStyle(
                            color: Color(0xFF0B8F4D),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
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
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum AlertType { urgent, warning, normal, success }