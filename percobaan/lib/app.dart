import 'package:flutter/material.dart';
import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/customer/main_screen.dart';
import 'screens/customer/catalog/product_detail_screen.dart';
import 'screens/customer/cart/cart_screen.dart';
import 'screens/customer/checkout/checkout_screen.dart';
import 'screens/customer/checkout/order_success_screen.dart';
import 'screens/customer/orders/order_status_screen.dart';
import 'screens/customer/promo/promo_screen.dart';
import 'screens/customer/help/help_screen.dart';
import 'screens/admin/main_admin_screen.dart';
import 'screens/admin/products/admin_add_edit_product_screen.dart';
import 'screens/admin/orders/admin_order_detail_screen.dart';

/// Entry point konfigurasi aplikasi DRS
class DRSApp extends StatelessWidget {
  const DRSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DRS - Donat Reinhard Samuel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // === Splash & Onboarding ===
          case AppRoutes.splash:
            return _build(const SplashScreen(), settings);
          case AppRoutes.onboarding:
            return _build(const OnboardingScreen(), settings);

          // === Auth ===
          case AppRoutes.login:
            return _build(const LoginScreen(), settings);
          case AppRoutes.register:
            return _build(const RegisterScreen(), settings);

          // === Customer ===
          case AppRoutes.customerMain:
            return _build(const CustomerMainScreen(), settings);
          case AppRoutes.productDetail:
            return _build(const ProductDetailScreen(), settings);
          case AppRoutes.cart:
            return _build(const CartScreen(), settings);
          case AppRoutes.checkout:
            return _build(const CheckoutScreen(), settings);
          case AppRoutes.orderSuccess:
            return _build(const OrderSuccessScreen(), settings);
          case AppRoutes.orderStatus:
            return _build(const OrderStatusScreen(), settings);
          case AppRoutes.promo:
            return _build(const PromoScreen(), settings);
          case AppRoutes.help:
            return _build(const HelpScreen(), settings);

          // === Admin ===
          case AppRoutes.adminMain:
            return _build(const AdminMainScreen(), settings);
          case AppRoutes.adminAddProduct:
            return _build(const AdminAddEditProductScreen(), settings);
          case AppRoutes.adminEditProduct:
            return _build(const AdminAddEditProductScreen(), settings);
          case AppRoutes.adminOrderDetail:
            return _build(const AdminOrderDetailScreen(), settings);

          default:
            return _build(const SplashScreen(), settings);
        }
      },
    );
  }

  MaterialPageRoute _build(Widget widget, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => widget,
      settings: settings,
    );
  }
}
