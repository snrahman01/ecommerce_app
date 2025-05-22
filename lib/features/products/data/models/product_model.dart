import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final List<String> images;
  final List<Review?> reviews;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.reviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      images: List<String>.from(json['images'] ?? []),
      reviews: (json['reviews'] as List).map((review) => Review.fromJson(review)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': images,
      'reviews': reviews?.map((review) => review?.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, title, price, description, category, images, reviews];
}

class Review extends Equatable {
  final int rating;
  final String? comment;

  const Review({
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rate': rating,
      'count': comment,
    };
  }

  @override
  List<Object?> get props => [rating, comment];
}
