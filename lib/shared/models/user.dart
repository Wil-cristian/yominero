import 'post.dart';

enum UserRole { admin, vendor, customer }

enum VerificationStatus { none, pending, verified }

class GeoLocation {
  final String? city;
  final String? country;
  final double? lat;
  final double? lng;
  const GeoLocation({this.city, this.country, this.lat, this.lng});
}

class PricingRange {
  final double from;
  final double to;
  final String unit; // e.g. "hora", "proyecto"
  const PricingRange(
      {required this.from, required this.to, required this.unit});
}

class AvailabilityWindow {
  final List<String> days; // e.g. ["Mon","Sat"]
  final String hours; // HH:MM-HH:MM
  const AvailabilityWindow({required this.days, required this.hours});
}

class ServiceOffering {
  final String name;
  final String category;
  final List<String> tags;
  final PricingRange? pricing;
  final AvailabilityWindow? availability;
  final int? coverageKm;
  const ServiceOffering({
    required this.name,
    required this.category,
    required this.tags,
    this.pricing,
    this.availability,
    this.coverageKm,
  });
}

class User {
  final String id;
  final String username;
  final String email;
  final String name;
  final UserRole role;
  final String? avatarUrl;
  final String? phone;
  final String? bio;

  // Extended profile
  final GeoLocation? location;
  final List<String> languages;
  final List<ServiceOffering> servicesOffered;
  final List<String> interests; // generic tags of interest
  final List<String> watchKeywords;
  // New preference fields for post suggestion personalization
  final Set<PostType>
      preferredPostTypes; // which post types user wants in suggestions
  final List<String>
      followedTags; // explicit tags the user chose to follow (beyond interests)
  final List<String> followedCategories; // categories user follows
  final VerificationStatus verificationStatus;
  final double ratingAvg;
  final int ratingCount;
  final int completedJobsCount;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    this.role = UserRole.customer,
    this.avatarUrl,
    this.phone,
    this.bio,
    this.location,
    this.languages = const ['es'],
    this.servicesOffered = const [],
    this.interests = const [],
    this.watchKeywords = const [],
    Set<PostType>? preferredPostTypes,
    this.followedTags = const [],
    this.followedCategories = const [],
    this.verificationStatus = VerificationStatus.none,
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.completedJobsCount = 0,
  }) : preferredPostTypes = preferredPostTypes ??
            const {
              PostType.community,
              PostType.request,
              PostType.offer,
            };

  User copyWith({
    String? username,
    String? email,
    String? name,
    UserRole? role,
    String? avatarUrl,
    String? phone,
    String? bio,
    GeoLocation? location,
    List<String>? languages,
    List<ServiceOffering>? servicesOffered,
    List<String>? interests,
    List<String>? watchKeywords,
    Set<PostType>? preferredPostTypes,
    List<String>? followedTags,
    List<String>? followedCategories,
    VerificationStatus? verificationStatus,
    double? ratingAvg,
    int? ratingCount,
    int? completedJobsCount,
  }) =>
      User(
        id: id,
        username: username ?? this.username,
        email: email ?? this.email,
        name: name ?? this.name,
        role: role ?? this.role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        phone: phone ?? this.phone,
        bio: bio ?? this.bio,
        location: location ?? this.location,
        languages: languages ?? this.languages,
        servicesOffered: servicesOffered ?? this.servicesOffered,
        interests: interests ?? this.interests,
        watchKeywords: watchKeywords ?? this.watchKeywords,
        preferredPostTypes: preferredPostTypes ?? this.preferredPostTypes,
        followedTags: followedTags ?? this.followedTags,
        followedCategories: followedCategories ?? this.followedCategories,
        verificationStatus: verificationStatus ?? this.verificationStatus,
        ratingAvg: ratingAvg ?? this.ratingAvg,
        ratingCount: ratingCount ?? this.ratingCount,
        completedJobsCount: completedJobsCount ?? this.completedJobsCount,
      );
}
