import 'package:atomic_webview/atomic_webview.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:jara_market/config/routes.dart';

class AtomicWebViewScreen extends StatefulWidget {
  AtomicWebViewScreen({super.key, this.url = ''});

  final String? url;

  @override
  State<AtomicWebViewScreen> createState() => _AtomicWebViewScreenState();
}

class _AtomicWebViewScreenState extends State<AtomicWebViewScreen> {
  WebViewController webViewController = WebViewController();

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
          title: Text("Pay with Paystack")),

      // body: WebView(
      //   controller: webViewController,
      // ),

      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: WebUri(widget.url ?? '')),
      ),
    );

    // return WebView(
    //   controller: webViewController,
    // );
  }
}
