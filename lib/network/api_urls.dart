class ApiEndpoints {
  //static const String baseUrlDev = "https://ngo.dinnovations.in/api";
  static const String baseUrlProd = "https://ngo.dinnovations.in/api";
  static const String baseImageUrl = "https://ngo.dinnovations.in/";
  static const String baseUrl = baseUrlProd;

  static String url(String endpoint) => baseUrl + endpoint;

  // ===================== AUTH =====================
  static const String onBoarding = "/on-boarding-screen";
  static const String register = "/register";
  static const String login = "/login";
  static const String logout = "/logout";
  static const String forgotPassword = '/forget-password';
  static const String resetPassword = "/reset-password";
  static const String changePassword = "/change-password";
  static const String settings = "/settings";

  // ===================== Category =====================
  static const String category = '/course-main-categories';
  static const String subCategory = '/course-sub-categories';


  // ===================== Cart =====================
  static const String cart = '/cart-list';
  static const String addToCart = '/add-to-cart';
  static const String removeCart = '/remove-from-cart';


  // ===================== Courses =====================
  static const String popularCourses = '/popular-courses';
  static const String freshCourses = '/fresh-courses';
  static const String enrolledCourses = '/enrolled-courses';
  static const String wishlistCourses = '/wishlist-courses';
  static const String courseLevels = '/course-levels';
  static const String courseLanguage = '/course-languages';
  static const String courseDetails = '/course';

  // ===================== Orders =====================
  static const String orders = "/orders";
  static const String downloadInvoice = "/download-invoice";

  // ===================== Payment Methods =====================
  static const String paymentMethodsList = "/payment-gateway-list";
  static const String paymentRazorpay = "/payment-api";
  static const String freeOrder = "/free-order";


  // ===================== Reviews =====================
  static const String reviews = '/course/reviews';

  // ===================== Learning =====================
  static const String learning = '/learning';

  // ===================== Search =====================
  static const String searchCourses = '/search-courses';
  static const String addRemoveWishlist = '/add-remove-wishlist';



  // ===================== Profile =====================
  static const String profile = '/profile';
  static const String updateProfilePicture = '/update-profile-picture';
  static const String updateSocialLinks = '/update-social-links';
  static const String updateBio = '/update-bio';
  static const String updateAddress = '/update-address';
  static const String updatePassword = '/update-password';
  static const String updateProfile = '/update-profile';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String faqs = '/faqs';
  static const String subscribeUs = '/subscribe-us';
  static const String contactUs = '/contact-us';
  static const String languageList = '/language-list';
  static const String privacyPolicy = '/privacy-policy';

}
