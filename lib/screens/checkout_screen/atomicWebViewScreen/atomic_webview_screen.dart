import 'package:atomic_webview/atomic_webview.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:jara_market/config/routes.dart';
import 'package:jara_market/screens/success_screen/success_screen.dart';

class AtomicWebViewScreen extends StatefulWidget {
  AtomicWebViewScreen({super.key, this.url = ''});

  final String? url;

  @override
  State<AtomicWebViewScreen> createState() => _AtomicWebViewScreenState();
}

class _AtomicWebViewScreenState extends State<AtomicWebViewScreen> {
  WebViewController webViewController = WebViewController();
  InAppWebViewController? webViewController1;
final String callback_url = "http://127.0.0.1:8000";

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   var url = widget.url ?? '';

    //   Loggerr.log("Paystack URL in webview page: $url");

    //   webViewController.init(
    //     context: context,
    //     setState: setState,
    //     uri: Uri.parse(url),
    //   );
    // });
  }

  final GlobalKey webViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).canPop()
                    ? Navigator.pop(context)
                    : Navigator.of(context).pushNamed(AppRoutes.mainScreen);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text("Pay with Paystack",style:TextStyle(fontFamily: 'Poppins',fontWeight:FontWeight.w600,fontSize:14))),

      // body: WebView(
      //   controller: webViewController,
      // ),

      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: WebUri(widget.url ?? '')),
        onWebViewCreated: (controller){
          webViewController1 = controller;
        },
        onLoadStop: (controller, url) {
          print("Loaded URL: $url");
          if (url.toString().startsWith(callback_url)) {
            // Detected redirect to callback URL
            Navigator.pop(context); // Close the WebView
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SuccessScreen()),
            );
          }
        },
      ),
    );

    // return WebView(
    //   controller: webViewController,
    // );
  }
}
