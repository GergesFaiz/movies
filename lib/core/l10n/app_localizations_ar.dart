// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'أفلام';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get theme => 'النمط';

  @override
  String get watch => 'مشاهدة';

  @override
  String get similar => 'مشابهة';

  @override
  String get summary => 'القصة';

  @override
  String get cast => 'طاقم العمل';

  @override
  String get genres => 'التصنيفات';

  @override
  String get watchlist => 'قائمة المشاهدة';

  @override
  String get history => 'سجل المشاهدة';

  @override
  String get noDescription => 'لا يوجد وصف متاح لهذا الفيلم.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما!';

  @override
  String get pleaseLoginFirst => 'يرجى تسجيل الدخول أولاً';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordTooShort => 'كلمة المرور يجب ألا تقل عن 6 أحرف';

  @override
  String get forgetPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح!';

  @override
  String get ok => 'موافق';

  @override
  String get error => 'خطأ';

  @override
  String get systemError => 'خطأ في النظام';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get createOne => ' أنشئ حساباً ';

  @override
  String get loginWithGoogle => ' تسجيل الدخول بواسطة جوجل ';

  @override
  String get name => 'الاسم';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get avatar => 'الصورة الشخصية';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get verifyEmail => 'التحقق من البريد';

  @override
  String get sendingResetLink => 'جاري إرسال رابط إعادة التعيين...';

  @override
  String get checkEmailToReset =>
      'تحقق من بريدك الإلكتروني لإعادة تعيين كلمة المرور!';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get enterYourName => 'أدخل اسمك';

  @override
  String get enterYourPhone => 'أدخل رقم هاتفك';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get updateData => 'تحديث البيانات';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get watchList => 'قائمة المشاهدة';

  @override
  String get emptyWatchList => 'قائمة المشاهدة الخاصة بك فارغة';

  @override
  String get emptyHistory => 'لم تقم بمشاهدة أي أفلام بعد';

  @override
  String get addToWatchList => 'إضافة إلى قائمة المشاهدة';

  @override
  String get removeFromWatchList => 'إزالة من قائمة المشاهدة';

  @override
  String get addedToWatchList => 'تمت الإضافة إلى قائمة المشاهدة بنجاح';

  @override
  String get removedFromWatchList => 'تمت الإزالة من قائمة المشاهدة بنجاح';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get accountCreated => 'تم إنشاء الحساب بنجاح!';

  @override
  String get or => 'أو';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get pageNotFound => 'الصفحة غير موجودة';

  @override
  String get home => 'الرئيسية';

  @override
  String get search => 'بحث';

  @override
  String get browse => 'تصفح';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get noMoviesFound => 'لا توجد أفلام';

  @override
  String get seeMore => 'عرض المزيد';

  @override
  String get all => 'الكل';

  @override
  String get screenshots => 'لقطات من الفيلم';

  @override
  String get trailerUnavailable => 'الإعلان غير متاح لهذا الفيلم.';

  @override
  String get couldNotOpenLink => 'تعذر فتح الرابط.';

  @override
  String get exit => 'خروج';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get deleteAccountConfirm =>
      'هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن ذلك.';

  @override
  String get unknown => 'غير معروف';

  @override
  String actorName(String name) {
    return 'الاسم: $name';
  }

  @override
  String characterName(String name) {
    return 'الشخصية: $name';
  }

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get invalidName => 'من فضلك أدخل اسماً صحيحاً (3 أحرف على الأقل)';

  @override
  String get invalidEmail =>
      'أدخل بريداً إلكترونياً صحيحاً (مثال: name@example.com)';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get invalidPhone => 'أدخل رقم هاتف مصري صحيح مكون من 11 رقماً';

  @override
  String get weakPassword =>
      'يجب أن تحتوي على حرف كبير وحرف صغير ورقم و8 أحرف على الأقل';

  @override
  String get confirmPasswordRequired => 'من فضلك أكّد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get exploreNow => 'استكشف الآن';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get finish => 'إنهاء';

  @override
  String get onboardingTitle1 => 'اعثر على فيلمك\nالمفضل التالي هنا';

  @override
  String get onboardingDescription1 =>
      'احصل على مكتبة ضخمة من الأفلام\nتناسب جميع الأذواق. بالتأكيد ستعجبك.';

  @override
  String get onboardingTitle2 => 'اكتشف الأفلام';

  @override
  String get onboardingDescription2 =>
      'استكشف مجموعة ضخمة من الأفلام بكل\nالجودات والتصنيفات. اعثر على فيلمك\nالمفضل التالي بسهولة.';

  @override
  String get onboardingTitle3 => 'استكشف كل التصنيفات';

  @override
  String get onboardingDescription3 =>
      'اكتشف أفلاماً من كل التصنيفات وبكل\nالجودات المتاحة. اعثر على شيء جديد\nومثير لتشاهده كل يوم.';

  @override
  String get onboardingTitle4 => 'أنشئ قوائم المشاهدة';

  @override
  String get onboardingDescription4 =>
      'احفظ الأفلام في قائمة المشاهدة لتتابع\nما تريد مشاهدته لاحقاً.\nاستمتع بأفلام بجودات\nوتصنيفات متنوعة.';

  @override
  String get onboardingTitle5 => 'قيّم، راجع، وتعلّم';

  @override
  String get onboardingDescription5 =>
      'شارك رأيك في الأفلام التي\nشاهدتها. تعمّق في تفاصيل الأفلام\nوساعد الآخرين على اكتشاف أفلام\nرائعة من خلال مراجعاتك.';

  @override
  String get onboardingTitle6 => 'ابدأ المشاهدة الآن';
}
