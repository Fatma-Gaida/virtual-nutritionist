import 'package:flutter/material.dart';

import 'package:flutter_application/screens/calorie_screen.dart';
import 'package:flutter_application/screens/profil_screen.dart';
import 'package:flutter_application/screens/water_tracker_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Static data for notification screen
  final String username = "Fatma Zahra";
  final String date = "May 1, 2025";
  
  // Example notifications data
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Goal Progress',
      message: 'You\'re only 5kg away from your weight goal! Keep it up!',
      time: '1h ago',
      icon: Icons.flag,
      iconColor: Colors.amber,
      isNew: true,
    ),
   
    NotificationItem(
      title: 'Water Reminder',
      message: 'Don\'t forget to drink your water! You\'re 0.5L behind today\'s goal.',
      time: '5h ago',
      icon: Icons.water_drop,
      iconColor: Colors.blue,
      isNew: false,
    ),
    
    NotificationItem(
      title: 'Motivation',
      message: 'Remember: Every small step counts towards your goal!',
      time: '2d ago',
      icon: Icons.emoji_events,
      iconColor: Colors.purple,
      isNew: false,
    ),
   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF2E6930),
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // This would open notification settings in a real app
              _showSettingsDialog(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildNotificationsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/profil.png'),
                radius: 20,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  // Mark all as read functionality
                  setState(() {
                    for (var notification in notifications) {
                      notification.isNew = false;
                    }
                  });
                },
                icon: Icon(Icons.done_all, size: 18, color: Color(0xFF2E6930)),
                label: Text(
                  'Mark all as read',
                  style: TextStyle(color: Color(0xFF2E6930), fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return notifications.isEmpty
        ? _buildEmptyState()
        : ListView.separated(
            padding: EdgeInsets.only(top: 8),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[200]),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationItem(notification);
            },
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'When you have new notifications, they\'ll appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      color: notification.isNew ? Color(0xFFEDF7ED) : Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: notification.iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            notification.icon,
            color: notification.iconColor,
            size: 28,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Text(
              notification.time,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              notification.message,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: notification.isNew ? Colors.grey[400] : Color(0xFF2E6930),
                ),
                SizedBox(width: 4),
                Text(
                  notification.isNew ? 'Unread' : 'Read',
                  style: TextStyle(
                    color: notification.isNew ? Colors.grey[600] : Color(0xFF2E6930),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Mark as read when tapped
          setState(() {
            notification.isNew = false;
          });
          
          // Show details in a dialog
          _showNotificationDetails(context, notification);
        },
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: notification.iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      notification.icon,
                      color: notification.iconColor,
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          notification.time,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Message:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.delete_outline),
                      label: Text('Dismiss'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text('Take Action'),
                      onPressed: () {
                        Navigator.pop(context);
                        // This would trigger the appropriate action based on notification type
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Action taken for: ${notification.title}'),
                            backgroundColor: Color(0xFF2E6930),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E6930),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notification Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSettingsOption('Progress Notifications', true),
            _buildSettingsOption('Water Reminders', true),
            _buildSettingsOption('Weekly Summary', true),
            _buildSettingsOption('Motivational Messages', false),
            _buildSettingsOption('Recipe Suggestions', true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2E6930),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(String title, bool initialValue) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SwitchListTile(
          title: Text(title),
          value: initialValue,
          onChanged: (value) {
            setState(() {
              // In a real app, this would update preferences
            });
          },
          activeColor: Color(0xFF2E6930),
        );
      },
    );
  }

   Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color.fromRGBO(46, 125, 50, 1),
      unselectedItemColor: Colors.grey,
      currentIndex: 0, // Home/Dashboard tab is selected
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Calories'),
        BottomNavigationBarItem(
          icon: Icon(Icons.water_drop),
          label: 'Water',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
      onTap: (index) {
        if (index == 1) {
          // Navigate to Calories screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalorieScreen()),
          );
        } else if (index == 3) {
          // Navigate to Water screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WaterTrackerScreen()),
          );
        } else if (index == 4) {
          // Navigate to Profile screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        }
      },
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  bool isNew;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.isNew,
  });
}