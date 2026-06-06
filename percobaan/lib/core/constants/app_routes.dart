/// Semua nama route dalam aplikasi DRS
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';

  // Customer
  static const String customerMain = '/customer/main';
  static const String customerHome = '/customer/home';
  static const String productList = '/customer/catalog';
  static const String productDetail = '/customer/product-detail';
  static const String cart = '/customer/cart';
  static const String checkout = '/customer/checkout';
  static const String orderSuccess = '/customer/order-success';
  static const String orderHistory = '/customer/order-history';
  static const String orderStatus = '/customer/order-status';
  static const String favorite = '/customer/favorite';
  static const String promo = '/customer/promo';
  static const String profile = '/customer/profile';
  static const String help = '/customer/help';

  // Admin
  static const String adminMain = '/admin/main';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminProducts = '/admin/products';
  static const String adminAddProduct = '/admin/products/add';
  static const String adminEditProduct = '/admin/products/edit';
  static const String adminOrders = '/admin/orders';
  static const String adminOrderDetail = '/admin/orders/detail';
  static const String adminPromo = '/admin/promo';
  static const String adminReport = '/admin/report';
}
