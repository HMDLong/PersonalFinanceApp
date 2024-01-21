import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';

List<NotificationChannel> channels = [
  NotificationChannel(
    channelKey: "1", 
    channelName: "main", 
    channelDescription: null,
    importance: NotificationImportance.High,
  ),
];

class NotificationService extends ChangeNotifier {  
  static void initialize() {
    AwesomeNotifications().initialize(null, channels);
  }

  static void askForPermissions() async {
    final isNotiAllowed = await AwesomeNotifications().isNotificationAllowed();
    if(!isNotiAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static void initListeners() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod:         onActionReceivedMethod,
      onNotificationCreatedMethod:    onNotificationCreatedMethod,
      onNotificationDisplayedMethod:  onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:  onDismissActionReceivedMethod,
    );
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
  }

  void registerOneTimeNoti() {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0, 
        channelKey: "1",
        title: "Hello world",
        body: "This is a noti",
      ),
    );
  }

  void scheduleNotification(ScheduledNotification noti, {bool demo = true}) {
    AwesomeNotifications().createNotification(
      schedule: demo 
      ? null
      : switch(noti.type){
        Periodic.daily => NotificationAndroidCrontab.daily(referenceDateTime: noti.referenceDateTime),
        Periodic.weekly => NotificationAndroidCrontab.weekly(referenceDateTime: noti.referenceDateTime),
        Periodic.monthly => NotificationAndroidCrontab.monthly(referenceDateTime: noti.referenceDateTime),
        Periodic.yearly => NotificationAndroidCrontab.yearly(referenceDateTime: noti.referenceDateTime),
        Periodic.onetime => null,
      },
      content: NotificationContent(
        id: noti.id, 
        channelKey: channels[0].channelKey!,
        notificationLayout: NotificationLayout.BigText,
        title: noti.title,
        body: noti.content,
        payload: noti.payload,
      ),
    );
  }

  void cancelNotification(int notiId) {
    AwesomeNotifications().cancelSchedule(notiId);
  }
}

