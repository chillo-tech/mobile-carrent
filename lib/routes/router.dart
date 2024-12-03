import 'package:carrent/src/features/my_posts/views/edit_post.dart';
import 'package:get/route_manager.dart';

import '../src/features/auth/forgot_password/views/enter_new_password.dart';
import '../src/features/auth/forgot_password/views/forgot_password.dart';
import '../src/features/auth/login/views/login.dart';
import '../src/features/auth/otp/views/confirm_otp.dart';
import '../src/features/auth/register/views/create_account.dart';
import '../src/features/booking/views/booking.dart';
import '../src/features/bottom_nav/views/bottom_nav.dart';
import '../src/features/create_post/views/create_post.dart';
import '../src/features/create_post/views/create_post_or_booking_success.dart';
import '../src/features/home/views/car_details.dart';
import '../src/features/home/views/home.dart';
import '../src/features/my_posts/views/my_posts.dart';
import '../src/features/my_posts/views/post_details.dart';
import '../src/features/notifications/views/notifications_screen.dart';
import '../src/features/search/search.dart';
import '../src/features/search_result/views/search_result.dart';
import '../src/features/settings/views/update_profile.dart';
import '../src/features/splash/splash.dart';
import '../src/features/success/success.dart';
import '../src/features/welcome/welcome.dart';
import '../src/features/withdraw_booking/views/withdraw_booking.dart';

class Router {
  static final route = [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/welcome', page: () => const Welcome()),
    GetPage(name: '/login', page: () => Login()),
    GetPage(name: '/home', page: () => Home()),
    GetPage(name: '/car_details', page: () => CarDetails()),
    GetPage(name: '/booking_withdraw', page: () => BookingWithdraw()),
    GetPage(name: '/booking', page: () => Booking()),
    GetPage(name: '/search', page: () => const SearchScreen()),
    GetPage(name: '/search_result', page: () => SearchResultScreen()),
    GetPage(name: '/bottom_nav', page: () => BottomNav()),
    GetPage(name: '/forgot_password', page: () => ForgotPassword()),
    GetPage(name: '/success', page: () => Success()),
    GetPage(name: '/enter_new_password', page: () => EnterNewPassword()),
    GetPage(name: '/create_account', page: () => CreateAccount()),
    GetPage(name: '/confirm_otp', page: () => ConfirmOtp()),
    GetPage(name: '/publications', page: () => MyPosts()),
    GetPage(name: '/create_post', page: () => CreatePost()),
    GetPage(name: '/success_post', page: () => CreatePostSuccess()),
    GetPage(name: '/post_details', page: () => PostDetails()),
    GetPage(name: '/edit_post', page: () => EditPost()),
    GetPage(name: '/update_profile', page: () => UpdateProfile()),
    GetPage(name: '/notification', page: () => NotificationsScreen()),
    
  ];
}
