import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatTabView extends ConsumerWidget {
  const ChatTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search chats feature coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New chat feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search doctors or chats...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
            ),
          ),
          
          // Chat list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 10, // Sample data
              itemBuilder: (context, index) {
                return _buildChatItem(context, index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Start new chat feature coming soon!')),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final isOnline = index % 3 == 0; // Sample online status
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: theme.primaryColor,
                size: 30,
              ),
            ),
            if (isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          'Dr. ${_getDoctorName(index)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _getLastMessage(index),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getTime(index),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (index % 2 == 0)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening chat with Dr. ${_getDoctorName(index)}')),
          );
        },
      ),
    );
  }

  String _getDoctorName(int index) {
    final names = [
      'Smith',
      'Johnson',
      'Williams',
      'Brown',
      'Jones',
      'Garcia',
      'Miller',
      'Davis',
      'Rodriguez',
      'Martinez',
    ];
    return names[index % names.length];
  }

  String _getLastMessage(int index) {
    final messages = [
      'How are you feeling today?',
      'Your appointment is confirmed for tomorrow',
      'Please take your medication as prescribed',
      'The test results are ready',
      'Don\'t forget your follow-up appointment',
      'Your prescription has been updated',
      'The lab work looks good',
      'Remember to stay hydrated',
      'Your symptoms are improving',
      'Schedule your next checkup',
    ];
    return messages[index % messages.length];
  }

  String _getTime(int index) {
    final times = [
      '2m ago',
      '5m ago',
      '1h ago',
      '2h ago',
      '3h ago',
      '1d ago',
      '2d ago',
      '3d ago',
      '1w ago',
      '2w ago',
    ];
    return times[index % times.length];
  }
} 