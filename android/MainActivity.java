if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) 
{
  Uri soundUri=Uri.parse("android.resource://"+getApplicationContext()
                    .getPackageName() + "/" +  R.raw.alert);
  AudioAttributes audioAttributes =AudioAttributes.Builder()
                  .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                  .setUsage(AudioAttributes.USAGE_ALARM)
                  .build();
  NotificationChannel channel = new 
  NotificationChannel("com.darulasar.Azkar","Azkar", 
  NotificationManager.IMPORTANCE_HIGH);
  channel.setSound(soundUri, audioAttributes);
  NotificationManager notificationManager = 
  getSystemService(NotificationManager.class);
  notificationManager.createNotificationChannel(channel);
 }