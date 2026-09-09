# المهام المطلوبة لربط Selector بأنواع الخدمات مع الـ API

- `[x]` إنشاء كيان `ServingTypeEntity`
- `[x]` إنشاء نموذج `ServingTypeModel`
- `[x]` إضافة رابط الـ API في `ApiStringConstants`
- `[x]` تحديث `ServicesRemoteDataSource` لإضافة `getServingTypes`
- `[x]` تحديث `ServicesRepository` لإضافة `getServingTypes`
- `[x]` تحديث `ServicesRepositoryImpl` لتنفيذ `getServingTypes`
- `[x]` إنشاء Use Case `GetServingTypesUseCase`
- `[x]` تحديث `ServicesEvent` لإضافة `GetServingTypesEvent`
- `[x]` تحديث `ServicesState` لإضافة حالات جلب الأنواع
- `[x]` تحديث `ServicesBloc` لمعالجة حدث جلب الأنواع
- `[x]` تحديث `injection_container.dart` لتسجيل التبعيات الجديدة
- `[x]` تحديث `ServiceTypeSelector` ليكون ديناميكياً
- `[x]` تحديث `PaidServicePage` لاستدعاء الـ API واستخدام البيانات
