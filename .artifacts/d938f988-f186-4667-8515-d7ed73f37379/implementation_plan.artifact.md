# إضافة ميزة تقييم الخدمة من صفحة طلباتي (Rate Serving from My Requests)

إضافة إمكانية تقييم الخدمات للمستخدمين الذين أكملوا طلباتهم، بحيث يظهر زر التقييم في كرت الطلب بصفحة "طلباتي" فقط عندما تكون حالة الطلب "مكتمل".

## Proposed Changes

### 1. Data Layer

#### [MODIFY] [services_remote_data_source.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/data/datasources/services_remote_data_source.dart)
- إضافة تابع `rateServing(int serviceId, double rating)` لإرسال التقييم.

#### [MODIFY] [services_repository.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/domain/repository/services_repository.dart)
- إضافة تعريف التابع `rateServing`.

#### [MODIFY] [services_repository_impl.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/data/repository/services_repository_impl.dart)
- تنفيذ التابع `rateServing` والتعامل مع `ServerExceptionWithDetails`.

### 2. Domain Layer

#### [NEW] [rate_serving_usecase.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/domain/usecases/service/rate_serving_usecase.dart)
- إنشاء UseCase للتقييم.

### 3. Presentation Layer

#### [MODIFY] [services_event.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/bloc/service/services_event.dart)
- إضافة `RateServingEvent(int serviceId, double rating)`.

#### [MODIFY] [services_bloc.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/bloc/service/services_bloc.dart)
- التعامل مع `RateServingEvent`.

#### [MODIFY] [services_state.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/bloc/service/services_state.dart)
- إضافة حالات التقييم (`RateServingLoading`, `RateServingSuccess`, `RateServingError`).

#### [NEW] [rating_dialog.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/widgets/services/rating_dialog.dart)
- إنشاء Dialog يحتوي على `RatingBar` (أو نجوم تفاعلية) لاختيار التقييم.

#### [MODIFY] [request_card.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/requests/presentation/widgets/request_card.dart)
- إضافة زر "قيم الآن" يظهر فقط عندما تكون حالة الطلب `COMPLETED`.

## Verification Plan

### Manual Verification
- الذهاب لصفحة "طلباتي".
- البحث عن طلب حالته "مكتمل".
- الضغط على زر التقييم واختيار عدد النجوم.
- التأكد من ظهور رسالة نجاح واختفاء الزر (أو تحديث الحالة) بعد التقييم بنجاح.
