// STRATEGY PATTERN
abstract class ServicePricingStrategy {
  double calculatePrice(double basePrice);
}

class BarterStrategy implements ServicePricingStrategy {
  // منطق "تبادلية"
  @override
  double calculatePrice(double basePrice) {
    return 0.0; // Barter, no price
  }
}

class PaidStrategy implements ServicePricingStrategy {
  // منطق "مدفوعة"
  @override
  double calculatePrice(double basePrice) {
    return basePrice;
  }
}

class VolunteerStrategy implements ServicePricingStrategy {
  // منطق "تطوعية"
  @override
  double calculatePrice(double basePrice) {
    return 0.0; // Volunteer, no price
  }
}