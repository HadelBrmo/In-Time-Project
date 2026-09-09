# الربط مع API لأنواع الخدمات (Serving Types)

سأقوم بتعديل `ServiceTypeSelector` ليقوم بجلب أنواع الخدمات من الـ API (`/serving-types`) بدلاً من استخدام قيم ثابتة. سأقوم أيضاً بتحديث الـ Bloc والـ Repository والـ Data Source لدعم هذا الطلب.

## مراجعة المستخدم مطلوبة

> [!IMPORTANT]
> لقطة الشاشة من Postman تظهر نوعين فقط: `paid` و `unpaid`. لكن الكود الحالي يحتوي على 3 أنواع: "تبادلية"، "تطوعية"، "مدفوعة".
> هل ترغب في عرض ما يعود من الـ API فقط (حتى لو كان نوعين)؟ أم أن هناك تعديل سيتم في الـ Backend ليعيد الأنواع الثلاثة؟
> سأقوم بالربط بحيث يعرض المكون ما يعود من الـ API بشكل ديناميكي.

## التغييرات المقترحة

### [Component] Domain Layer

#### [NEW] [serving_type_entity.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/domain/entity/serving_type_entity.dart)
إنشاء الكيان الخاص بنوع الخدمة.

#### [NEW] [get_serving_types_usecase.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/domain/usecases/service/get_serving_types_usecase.dart)
إنشاء Use Case لجلب أنواع الخدمات.

#### [MODIFY] [servicesRepository.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/domain/repository/servicesRepository.dart)
إضافة `getServingTypes` للواجهة.

---

### [Component] Data Layer

#### [NEW] [serving_type_model.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/data/models/serving_type_model.dart)
إنشاء نموذج البيانات الخاص بنوع الخدمة مع تحويل JSON.

#### [MODIFY] [services_remote_data_source.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/data/datasources/services_remote_data_source.dart)
إضافة تنفيذ جلب البيانات من الـ API.

#### [MODIFY] [services_repository_impl.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/data/repository/services_repository_impl.dart)
تنفيذ استدعاء الـ Data Source ومعالجة الاستثناءات.

#### [MODIFY] [app_strings.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/core/constants/app_strings.dart)
إضافة ثابت لـ `/serving-types`.

---

### [Component] Presentation Layer

#### [MODIFY] [services_event.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/bloc/service/services_event.dart)
إضافة `GetServingTypesEvent`.

#### [MODIFY] [services_state.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/bloc/service/services_state.dart)
إضافة حالات التحميل، النجاح، والفشل لجلب الأنواع.

#### [MODIFY] [services_bloc.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/bloc/service/services_bloc.dart)
معالجة الحدث الجديد واستدعاء الـ Use Case.

#### [MODIFY] [buildTypeSelector.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/widgets/services/buildTypeSelector.dart)
تحديث الودجت لتقبل قائمة من `ServingTypeEntity` بدلاً من استخدام قائمة ثابتة.

#### [MODIFY] [paid_strategy.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/servings/presentation/pages/services/paid_strategy.dart)
- استدعاء `GetServingTypesEvent` عند التشغيل.
- مراقبة حالة الـ Bloc لتحديث قائمة الأنواع.
- تمرير البيانات المستلمة لـ `ServiceTypeSelector`.

---

### [Component] Injection

#### [MODIFY] [injection_container.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/injection_container.dart)
تسجيل الـ Use Case الجديد وربطه بالـ Bloc والـ Repository.

## خطة التحقق

### التحقق اليدوي
- التأكد من جلب البيانات بنجاح عند فتح الصفحة.
- التأكد من أن الـ Selector يظهر الأسماء القادمة من السيرفر.
- التأكد من أن التنقل بين الصفحات لا يزال يعمل بشكل صحيح (بناءً على الترتيب أو الاسم).
