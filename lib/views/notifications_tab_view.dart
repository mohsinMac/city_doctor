import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsTabView extends ConsumerWidget {
  const NotificationsTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mark all as read feature coming soon!')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$value feature coming soon!')),
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Filter',
                child: Text('Filter'),
              ),
              const PopupMenuItem(
                value: 'Settings',
                child: Text('Settings'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Appointments', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Messages', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Reminders', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Updates', false),
                ],
              ),
            ),
          ),
          
          // Notifications list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 15, // Sample data
              itemBuilder: (context, index) {
                return _buildNotificationItem(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // Handle filter selection
      },
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue,
    );
  }

  Widget _buildNotificationItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final notification = _getNotificationData(index);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: notification['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            notification['icon'],
            color: notification['color'],
            size: 24,
          ),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontWeight: notification['isUnread'] ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['message'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              notification['time'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: notification['isUnread']
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening notification: ${notification['title']}')),
          );
        },
        onLongPress: () {
          _showNotificationOptions(context);
        },
      ),
    );
  }

  Map<String, dynamic> _getNotificationData(int index) {
    final notifications = [
      {
        'title': 'Appointment Confirmed',
        'message': 'Your appointment with Dr. Smith has been confirmed for tomorrow at 2:00 PM.',
        'time': '2 minutes ago',
        'icon': Icons.calendar_today,
        'color': Colors.green,
        'isUnread': true,
      },
      {
        'title': 'New Message',
        'message': 'Dr. Johnson sent you a message about your recent test results.',
        'time': '5 minutes ago',
        'icon': Icons.message,
        'color': Colors.blue,
        'isUnread': true,
      },
      {
        'title': 'Medication Reminder',
        'message': 'Time to take your evening medication. Don\'t forget!',
        'time': '1 hour ago',
        'icon': Icons.medication,
        'color': Colors.orange,
        'isUnread': false,
      },
      {
        'title': 'Test Results Ready',
        'message': 'Your blood test results are now available in your health records.',
        'time': '2 hours ago',
        'icon': Icons.assignment,
        'color': Colors.purple,
        'isUnread': false,
      },
      {
        'title': 'Appointment Reminder',
        'message': 'Reminder: You have an appointment with Dr. Williams tomorrow.',
        'time': '3 hours ago',
        'icon': Icons.notifications,
        'color': Colors.red,
        'isUnread': false,
      },
      {
        'title': 'Prescription Updated',
        'message': 'Your prescription has been updated. Check your medications.',
        'time': '1 day ago',
        'icon': Icons.local_pharmacy,
        'color': Colors.teal,
        'isUnread': false,
      },
      {
        'title': 'Health Tips',
        'message': 'Weekly health tips: Stay hydrated and exercise regularly.',
        'time': '1 day ago',
        'icon': Icons.health_and_safety,
        'color': Colors.indigo,
        'isUnread': false,
      },
      {
        'title': 'Insurance Update',
        'message': 'Your insurance information has been updated successfully.',
        'time': '2 days ago',
        'icon': Icons.security,
        'color': Colors.amber,
        'isUnread': false,
      },
      {
        'title': 'Lab Appointment',
        'message': 'Your lab appointment has been scheduled for next week.',
        'time': '2 days ago',
        'icon': Icons.science,
        'color': Colors.cyan,
        'isUnread': false,
      },
      {
        'title': 'Follow-up Required',
        'message': 'Please schedule a follow-up appointment with your doctor.',
        'time': '3 days ago',
        'icon': Icons.medical_services,
        'color': Colors.deepOrange,
        'isUnread': false,
      },
      {
        'title': 'Emergency Contact',
        'message': 'Your emergency contact information has been verified.',
        'time': '3 days ago',
        'icon': Icons.emergency,
        'color': Colors.red,
        'isUnread': false,
      },
      {
        'title': 'Health Records',
        'message': 'New health records have been added to your profile.',
        'time': '1 week ago',
        'icon': Icons.folder,
        'color': Colors.grey,
        'isUnread': false,
      },
      {
        'title': 'App Update',
        'message': 'A new version of City Doctor app is available.',
        'time': '1 week ago',
        'icon': Icons.system_update,
        'color': Colors.lightBlue,
        'isUnread': false,
      },
      {
        'title': 'Privacy Policy',
        'message': 'Our privacy policy has been updated. Please review.',
        'time': '1 week ago',
        'icon': Icons.privacy_tip,
        'color': Colors.lime,
        'isUnread': false,
      },
      {
        'title': 'Welcome Message',
        'message': 'Welcome to City Doctor! We\'re here to help with your health.',
        'time': '2 weeks ago',
        'icon': Icons.waving_hand,
        'color': Colors.pink,
        'isUnread': false,
      },
    ];
    
    return notifications[index % notifications.length];
  }

  void _showNotificationOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.mark_email_read),
              title: const Text('Mark as read'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mark as read feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete notification'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Delete notification feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Notification settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification settings feature coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 