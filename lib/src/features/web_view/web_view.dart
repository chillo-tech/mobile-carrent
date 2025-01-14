import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReservationWebView extends StatelessWidget {
  ReservationWebView({super.key});
  late WebViewController _controller;
  String car = Get.arguments['car'];
  String url = Get.arguments['url'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation pour $car'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
          
          if (url.contains('success') || url.contains('cancel')) {
            var splitedRequestUrl = url.split('/');
            Get.back(result: splitedRequestUrl.contains('success'));
          }
        },
        navigationDelegate: (NavigationRequest request) {
          print("REQUEST NAV: ${request.url}");

          if (request.url.startsWith('https://')) {
            return NavigationDecision.navigate;
          } else {
            // Handle the redirection or block it
            return NavigationDecision.prevent;
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _controller.goBack();
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                _controller.goForward();
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _controller.reload();
              },
            ),
          ],
        ),
      ),
    );
  }
}
// class ReservationWebView extends StatefulWidget {
//   ReservationWebView({super.key});

//   @override
//   _ReservationWebViewState createState() => _ReservationWebViewState();
// }

// class _ReservationWebViewState extends State<ReservationWebView> {
//   late WebViewController _controller;
//   bool isLoading = true;
//   String car = Get.arguments['car'];
//   String url = Get.arguments['url'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reservation pour $car'),
//       ),
//       body: Stack(
//         children: [
//           WebView(
//             initialUrl: url,
//             javascriptMode: JavascriptMode.unrestricted,
//             onWebViewCreated: (WebViewController webViewController) {
//               _controller = webViewController;
//             },
//             onPageStarted: (String url) {
//               setState(() {
//                 isLoading = true;
//               });
//             },
//             onPageFinished: (String url) {
//               setState(() {
//                 isLoading = false;
//               });
//             },
//             navigationDelegate: (NavigationRequest request) {
//               if (request.url.startsWith('https://')) {
//                 return NavigationDecision.navigate;
//               } else {
//                 return NavigationDecision.prevent;
//               }
//             },
//           ),
//           isLoading
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : Container(),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () {
//                 _controller.goBack();
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.arrow_forward),
//               onPressed: () {
//                 _controller.goForward();
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.refresh),
//               onPressed: () {
//                 _controller.reload();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }