import 'dart:async';

import 'package:Smart_Attendance/core/config.dart';
import 'package:Smart_Attendance/core/loading_indicator.dart';
import 'package:Smart_Attendance/core/user_shared_pref.dart';
import 'package:Smart_Attendance/model/device_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

String firstUrl = "   ";

class HomePageView extends StatefulWidget {
  final String? tempUrl;
  final String? token;
  final int? selectedIndex;
  final String? goingTO;

  const HomePageView({
    super.key,
    this.tempUrl,
    this.selectedIndex,
    this.token,
    this.goingTO,
  });

  @override
  State<HomePageView> createState() => HomePageViewState();
}

class HomePageViewState extends State<HomePageView> {
  UserSharedPrefs usp = UserSharedPrefs();
  InAppWebViewController? webViewController;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isConnected = Config.getInternet();
  final GlobalKey webViewKey = GlobalKey();
  String tempUrl = Config.getHomeUrl();

  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    builtInZoomControls: false,
    displayZoomControls: false,
    useWideViewPort: true,
    iframeAllowFullscreen: true,
    supportZoom: false,
    javaScriptEnabled: true,
    cacheMode: CacheMode.LOAD_NO_CACHE,
    useHybridComposition: true,
    allowUniversalAccessFromFileURLs: true,
    clearSessionCache: false,
    supportMultipleWindows: true,
    allowFileAccessFromFileURLs: true,
  );
  PullToRefreshController? pullToRefreshController;

  String initUrl = Config.getHomeUrl();
  String url = Config.getHomeUrl();
  String? token;
  bool isLoading = false;
  DeviceModel? info;
  double progress = 0;
  final urlController = TextEditingController();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String displayText = "This page displays a webview for the attendance system";
  @override
  void initState() {
    super.initState();
    checkConnectivity();

    tempUrl = (widget.tempUrl != null && widget.tempUrl!.isNotEmpty)
        ? widget.tempUrl!
        : Config.getHomeUrl();

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.blue),
      onRefresh: _handleRefresh,
    );
  }

  Future<void> checkConnectivity() async {
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result.first != ConnectivityResult.none;
        Config.hasInternet(_isConnected);
      });
    });
    if (_isConnected) {
      _applySettingsAndReload();
    }
  }

  Future<void> _applySettingsAndReload() async {
    if (webViewController != null) {
      if (url == initUrl ||
          url == "$initUrl/login" ||
          url == "$initUrl/cpaneladmin" ||
          url == "$initUrl/forgot_password") {
        if (mounted) {
          setState(() {
            url = "$initUrl/dashboard";
          });
        }
      }

      try {
        bool hasTempUrl = tempUrl != "";
        webViewController?.loadUrl(
          urlRequest: URLRequest(url: WebUri(hasTempUrl ? tempUrl : url)),
        );
      } catch (e) {
        print("Error in loading url: $e");
      }
    }
  }

  Future<void> _handleRefresh() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await checkConnectivity();
    await InAppWebViewController.clearAllCache();
    await webViewController?.reload();
    pullToRefreshController?.endRefreshing();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: displayText ==
              'This page displays user profile in the attendance system'
          ? AppBar(
              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              backgroundColor: const Color(0xFF346CB0),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    await UserSharedPrefs().deleteToken();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: Colors.orange,
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              child: _isConnected
                  ? Center(child: Text(displayText))
                  : const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              color: Colors.redAccent,
                              size: 100,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'No Internet Connection',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Please check your internet settings and try again.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
            ),
            if (isLoading)
              Container(
                color: Colors.white.withValues(),
                child: const Center(
                  child: CustomLoadingIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> injectProfileButtonScript() async {
    setState(() {
      isLoading = true;
    });
    displayText = "This page displays user profile in the attendance system";
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> injectHomeButtonScript() async {
    setState(() {
      isLoading = true;
    });
    displayText = "This page displays home page of the attendance system";
    await Future.delayed(const Duration(milliseconds: 750));
    setState(() {
      isLoading = false;
    });
  }
}

class NotificationHandler {
  static Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}

  static void onMessageOpenedApp(Function(RemoteMessage message) listener) {
    FirebaseMessaging.onMessageOpenedApp.listen(listener);
  }

  static void onMessage(Function(RemoteMessage message) listener) {
    FirebaseMessaging.onMessage.listen(listener);
  }
}
