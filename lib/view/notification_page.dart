import 'package:Smart_Attendance/core/config.dart';
import 'package:Smart_Attendance/core/user_shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:refresh/refresh.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationItem> notifications = [];
  bool isLoading = true;
  UserSharedPrefs usp = UserSharedPrefs();
  String? token;
  String initUrl = Config.getHomeUrl();
  int? empId;
  List<bool> isExpanded = [];
  final ScrollController _scrollController = ScrollController();

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    getNoti();
  }

  Future<void> getNoti() async {
    await Future.delayed(const Duration(seconds: 1));

    List<NotificationItem> fetchedNotifications = [
      NotificationItem(
        id: 1,
        empid: 101,
        title: "System Update",
        message:
            "<p>We have updated the system to version 2.0. Please check the new features.</p>",
        date: DateTime.now().subtract(const Duration(hours: 1)),
        read: false,
      ),
      NotificationItem(
        id: 2,
        empid: 102,
        title: "Meeting Reminder",
        message: "<p>Don't forget the team meeting at 3:00 PM today.</p>",
        date: DateTime.now().subtract(const Duration(days: 1)),
        read: false,
      ),
      NotificationItem(
        id: 3,
        empid: 103,
        title: "Holiday Announcement",
        message: "<p>Office will be closed on 25th December for Christmas.</p>",
        date: DateTime.now().subtract(const Duration(days: 3)),
        read: true,
      ),
    ];

    setState(() {
      notifications = fetchedNotifications;
      isLoading = false;
    });
  }

  Future<void> updateNoti(int id, int empid) async {}

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      getNoti();
    });
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    final yesterday = DateTime(today.year, today.month, today.day - 1);

    final todayNotifications = notifications
        .where((n) =>
            n.date.isAfter(DateTime(today.year, today.month, today.day)) &&
            n.date.isBefore(tomorrow))
        .toList();

    final yesterdayNotifications = notifications
        .where((n) =>
            n.date.isAfter(
                DateTime(yesterday.year, yesterday.month, yesterday.day)) &&
            n.date.isBefore(DateTime(today.year, today.month, today.day)))
        .toList();

    final earlierNotifications = notifications
        .where((n) => n.date
            .isBefore(DateTime(yesterday.year, yesterday.month, yesterday.day)))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF346CB0),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  if (index < todayNotifications.length) {
                    return _buildNotificationTile(
                        todayNotifications[index], index);
                  } else if (index <
                      todayNotifications.length +
                          yesterdayNotifications.length) {
                    return _buildNotificationTile(
                        yesterdayNotifications[
                            index - todayNotifications.length],
                        index);
                  } else {
                    return _buildNotificationTile(
                        earlierNotifications[index -
                            todayNotifications.length -
                            yesterdayNotifications.length],
                        index);
                  }
                },
              ),
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItem notification, int index) {
    return GestureDetector(
      onTap: () async {
        isExpanded[index] = !isExpanded[index];

        notification.read = true;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color:
              notification.read ? Colors.black.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Icon(
              Icons.notifications,
              color: notification.read ? Colors.grey : Colors.blue,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Html(data: notification.message),
                  // isExpanded[index]
                  //     ? Html(data: notification.message)
                  //     : _buildTruncatedHtml(notification.message),
                  const SizedBox(height: 5),
                  Text(
                    '${notification.date.toLocal()}'.split(' ')[0],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
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
}

class NotificationItem {
  final String title;
  final String message;
  final DateTime date;
  bool read;
  final int id;
  final int empid;

  NotificationItem({
    required this.title,
    required this.message,
    required this.date,
    required this.id,
    required this.empid,
    this.read = false,
  });
}

Widget _buildTruncatedHtml(String htmlData) {
  final plainText = _convertHtmlToPlainText(htmlData);
  final truncatedText =
      plainText.length > 100 ? '${plainText.substring(0, 100)}...' : plainText;

  return Text(
    truncatedText,
    style: const TextStyle(
      fontSize: 14,
      color: Colors.black54,
    ),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  );
}

String _convertHtmlToPlainText(String htmlData) {
  final document = html_parser.parse(htmlData);
  return document.body?.text ?? '';
}
