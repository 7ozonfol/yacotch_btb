/// API
// ignore_for_file: constant_identifier_names

class APIUrls {
//google map
  static const address = 'https://maps.googleapis.com/maps/api/geocode/json?';

  /// Domain url
  static const BASE_URL = "https://api.yacotch.online/api";
  static const new_BASE_URL = "https://api.yacotch.com/api";

  static const BASE_JSON_PLACEHOLDER = "https://jsonplaceholder.typicode.com/";

  /// Urls
  static const API_LOGIN = "/TokenAuth/Authenticate";
  static const API_Upload_Image = "/services/app/Image/UploadImage";
  static const API_REGISTER_TRAINER = "/services/app/Account/RegisterTrainer";
  static const API_CREATE_REST = "/services/app/Restaurant/Create";
  static const API_CREATE_SHOP = "/services/app/Shop/Create";
  static const API_REGISTER_REST = "/services/app/Account/RegisterRestaurant";
  static const API_REGISTER_SHOP = "/services/app/Account/RegisterShop";
  static const API_FORGETPASSWORD = "/services/app/Account/ForgotPassword";
  static const API_VERIFY_ACCOUNT = "/services/app/Account/VerifyAccount";
  static const API_VERIFY_RESEND_CODE = "/services/app/Account/ResendCode";
  static API_DELETE_ACCOUNT(String type) => "/services/app/$type/DeleteAccount";
  static const API_PRIVACY_PLICY =
      '/services/app/Configuration/GetPrivacyPolicy';
  static const API_ABOUT_APP = '/services/app/Configuration/GetAboutYacotch';
  static const API_VERIFY_FORGETPASSWORD =
      "/services/app/Account/ConfirmForgotPassword";
  static const API_GET_COURSES = "/services/app/Course/GetAll";
  static const API_GET_NEW_TRAINEES = "/services/app/Trainee/GetNewTrainees";
  static const API_GET_TRAINER_PROFILE = "/services/app/Trainer/GetProfile";
  static const API_COURSE_CREATE = "/services/app/Course/Create";
  static const API_GET_TRAINER_REVIEWS = "/services/app/Review/GetAll";
  static const API_GET_COURSE = "/services/app/Course/Get";
  static const API_GET_TRAINEE =
      "/services/app/Trainee/GetTraineeProgressInCourse";
  static const API_UPDATE_TRAINEE_PROGRESS =
      "/services/app/Trainee/UpdateTraineeProgress";
  static const API_GET_BOOKING_REQUESTS = "/services/app/BookingRequest/GetAll";
  static const API_APPROVE_BOOKING_REQUEST =
      "/services/app/BookingRequest/Approve";
  static const API_REJECT_BOOKING_REQUEST =
      "/services/app/BookingRequest/Reject";
  static const API_GET_SUBSCRIPTIONS = "/services/app/Subscription/GetAll";
  static const API_GET_NOTIFICATIONS = "/services/app/Notification/GetAll";
  static const API_CREATE_NOTIFICATIONS =
      "/services/app/Notification/SendNewMessageNotification";

  static const API_UPDATE_DEVICE_TOKEN =
      "/services/app/Account/UpdateUserFirebaseToken";
  static const API_CREATE_REPORT = "/services/app/Report/Create";

  //rest
  static const API_GET_REST_PROFILE = "/services/app/Restaurant/Get";
  static const API_UPDATE_REST_PROFILE = "/services/app/Restaurant/Update";

  static const API_Create_Dish = "/services/app/Dish/Create";
  static const API_GetAll_Category = "/services/app/Category/GetAll";
  static const API_GetAll_Index = "/services/app/Index/GetAll";
  static const API_GetAll_Dish_MostOrdered =
      "/services/app/Dish/GetAll?Sorting=MostOrdered&MaxResultCount=10";
  static const API_GetAll_Dish = "/services/app/Dish/GetAll";
  static const API_Get_Dish_Details = "/services/app/Dish/Get";
  static const API_GetAll_New_Ordered =
      "/services/app/Dish/GetNewOrderedDishes?MaxResultCount=10";
  static const API_GetAll_Order = "/services/app/Order/GetAll";
  static const API_GetNewOrderedDishes_Dish =
      "/services/app/Dish/GetNewOrderedDishes";
  static const API_ChangeStatus_Order = "/services/app/Order/ChangeStatus";

  // product
  static const API_GetAll_Product_MostOrdered =
      "/services/app/Product/GetAll?Sorting=CreationTime&MaxResultCount=10";
  static const API_GET_SHOP_PROFILE = "/services/app/Shop/Get";
  static const API_UPDATE_SHOP_PROFILE = "/services/app/Shop/Update";
  static const API_Create_Product = "/services/app/Product/Create";
  static const API_GetAll_Product = "/services/app/Product/GetAll";
  static const API_Get_Product_Details = "/services/app/Product/Get";
  static const API_Get_Payment_Create = "/services/app/Payment/Create";
  static const API_UPDATE_TRAINER_PROFILE =
      "/services/app/Trainer/UpdateProfile";
  static const API_AssignSubscriptionToUser =
      "/services/app/Subscription/AssignSubscriptionToUser";
  static const API_Logout = "/Account/logout";
  static const API_ChangePassword = "/services/app/User/ChangePassword";
}
