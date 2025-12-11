import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const GaguApp());
}

class GaguApp extends StatelessWidget {
  const GaguApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GAGU HK',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF141E30)),
        useMaterial3: true,
      ),
      // أول شاشة تظهر للمستخدم.
      home: const SplashScreen(),
    );
  }
}

// شاشة Splash الرئيسية بتصميم بسيط وحديث قبل الدخول للـ WebView.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ننتظر ثوانٍ بسيطة ثم ننتقل تلقائياً إلى صفحة الـ WebView.
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const GaguWebPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // واجهة بسيطة تحتوي على خلفية متدرجة، شعار، اسم العلامة، وصف قصير، ومؤشر تحميل.
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // مكان مخصص للّوجو، استبدل المسار بالمسار الصحيح للصورة في مشروعك.
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFE0E0E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'GAGU HK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Premium Furniture & Home Decor',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// صفحة تعرض موقع GAGU HK داخل WebView.
class GaguWebPage extends StatefulWidget {
  const GaguWebPage({super.key});

  @override
  State<GaguWebPage> createState() => _GaguWebPageState();
}

class _GaguWebPageState extends State<GaguWebPage> {
  // متحكم WebView لإدارة التحميل والتنقل داخل الصفحة.
  late final WebViewController _controller;

  // نستخدم هذا المتغير لإظهار/إخفاء مؤشر التحميل فوق الـ WebView.
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // تهيئة WebView مع السماح بالجافاسكربت وتعريف سلوكيات التحميل والأخطاء.
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            // هنا تقدر تضيف هاندل للأخطاء إذا تحب
          },
        ),
      )
      ..loadRequest(Uri.parse('https://gaguhk.com/'));
  }

  @override
  Widget build(BuildContext context) {
    // واجهة صفحة الـ WebView مع AppBar وزر إعادة تحميل ومؤشر تحميل فوق المحتوى.
    return Scaffold(
      appBar: AppBar(
        title: const Text('GAGU HK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
